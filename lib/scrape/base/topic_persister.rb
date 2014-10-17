module Scrape
  class TopicPersister
    include Scrape::Saving
    extend Forwardable

    def initialize(topic_scraper)
      @scraper = topic_scraper
      @logger = @scraper.logger ? @scraper.logger : Scrape::Logger.new
    end

    attr_accessor :logger
    def_delegators :@scraper, :record, :record=

    def save
      @scraper.scrape(after: :save) unless self.record
      return if record.persisted? && !record.changed?

      save_calendar
      if save_self_and_events
        save_images
      end
      @scraper
    end

    def save_calendar
      if @scraper.calendar_scraper
        @scraper.calendar_scraper.save
        new_cal = @scraper.calendar_scraper.record

        if new_cal
          # :#{ new_cal.id || new_cal.title}
          log_msg = "Add Calendar to Topic:#{record.id || record.title}"
          logger.with_logging([:debug, :info], log_msg, :subject_id, subject:new_cal) do
            @scraper.record.calendar = new_cal
          end
        end
      end
    end

    def save_images
      if @scraper.image_scrapers
        @scraper.image_scrapers.each { |img| img.save_image_to(self) }
      end
    end

    def save_self_and_events
      persisted = find_identical_scraped_record

      if !record.valid?
        log_msg = "Validation errors. ERRORS: #{record.errors.messages} OBJECT: #{record.inspect}"
        logger.write(:error, log_msg, subject:record)
        nil
      elsif persisted.nil? # no match! save!
        save_record
      elsif !persisted.scraped? # a user is maintaining this record, do nothing.
        return nil
      else
        update_persisted(persisted)
      end
    end

    # identical = same title && url, superset of self's events
    def find_identical_scraped_record
      persisted = Topic.where(title: record.title, url: record.url)

      if persisted.size == 1
        old_times = persisted.first.events.map { |e| [e.time, e.venue_id] }
        new_times = record.events.map          { |e| [e.time, e.venue_id] }

        if ((old_times & new_times) == new_times)
          # logger.write :debug, "Topic found! #{persisted.first.inspect}", subject:persisted.first
          return persisted.first
        end
      elsif persisted.size > 1
        logger.write :warn, "Topics #{p persisted.map(&:id)}", subject:persisted.first
        raise DuplicateRecordError.new, "Topics #{persisted.map(&:id)}"
      end unless !persisted
      nil
    end
  end
end
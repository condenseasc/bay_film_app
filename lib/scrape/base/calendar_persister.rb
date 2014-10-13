require 'scrape/logger'

module Scrape
  class CalendarPersister
    include Scrape::Saving
    extend Forwardable

    def initialize(calendar_scraper)
      @scraper = calendar_scraper
      @logger = @scraper.logger ? @scraper.logger : Scrape::Logger.new 
    end

    attr_accessor :logger
    def_delegators :@scraper, :record, :record=

    def save
      success = save_self # if already saved and not changed, returns here
      save_images
      return success
    end

    def save_images
      if @scraper.image_scrapers
        @scraper.image_scrapers.each { |img| img.save_image_to(self) }
      end
    end

    def save_self
      @scraper.scrape(after: :save) unless self.record
      return if record.persisted? && !record.changed?
      
      persisted = find_identical_scraped_record

      if !record.valid?
        logger.write(:error, "Validation errors. ERRORS: #{record.errors.messages} OBJECT: #{record.inspect}", subject:record)
        nil
      elsif persisted.nil? # no match! save!
        save_record
      elsif !persisted.scraped? # a user is maintaining this record, do nothing.
        return nil
      else
        update_persisted(persisted)
      end
    end

    # provisional!! calendars need owners to really give identity
    # identical = same name
    def find_identical_scraped_record
      persisted = Calendar.where(title: record.title)

      if persisted.size == 1
        return persisted.first
      elsif persisted.size > 1
        logger.write :warn, "Multiple Duplicate Calendars:#{persisted.map(&:id)}", subject:persisted.first

        raise DuplicateRecordError.new, "Calendars:#{persisted.map(&:id)}"
      end unless !persisted
    end
  end
end
require 'scrape/logger'
require 'scrape/saving'

module Scrape
  class ImagePersister
    include Scrape::Saving

    extend Forwardable

    def initialize(image_scraper)
      @scraper = image_scraper
    end

    def_delegators :@scraper, :record, :record=
    attr_accessor :logger

    def save_image_to(other)
      record = _save_image_to(other)
    end

    def save_image_to(other)
      unless /Scrape/.match(other.class.name + other.class.superclass.name)
        raise 'save_image_to called on a non scraper' 
      end

      @logger = other.logger ? other.logger : Scrape::Logger.new
      other.save if other.record.new_record?

      @scraper.with_temp_image do |tmp_img|
        record.asset = tmp_img
        if !record.valid?
          logger.add_log(:error, "Validation errors. ERRORS: #{record.errors.messages} OBJECT: #{record.inspect}", subject:record)
          record.errors
        else # check whether other has this image. if so, update that record if this one's bigger.
          match = false
          other.record.images.each do |persisted|
            if Compare::Images.duplicate?(persisted.asset.path, tmp_img.path)
              match = true

              if persisted.asset.size < tmp_img.size
                persisted.asset = tmp_img

                success = logger.with_logging([:debug, :info], "Update Image:#{persisted.id} with #{record.source_url}", subject:persisted) do
                  persisted.save!
                end

                # with other's images updated, update the ImageScraper with the same record
                @scraper.record = persisted if success
                success
              end
            end
          end

          if !match # No matches found, save new Image in ImageScraper, put that Image on other's record
            log_msg = "Add new image to #{other.record.class}:#{other.record.id} from #{record.source_url}"
            success = logger.with_logging([:debug, :info], log_msg, :subject_id, subject:record) do
              record.save!
            end
            other.record.images << record if success
            success
          end
        end
      end
    end

  end
end
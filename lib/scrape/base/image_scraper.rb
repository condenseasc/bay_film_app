require 'local_resource'
require 'compare'
require 'scrape/logger'
require 'scrape/base/image_persister'

class ImageScraper  
  extend Forwardable
  RECORD_METHODS = %w[id source_url source_url= alt alt= image image= persisted? new_record? valid?]

  attr_accessor :record, :temp_image, :logger
  def_delegators :@record, :title, :title=, :alt, :alt=, :source_url, :source_url=

  def initialize(url=nil, alt:nil, title:nil, log_tags:nil)
    @logger = Scrape::Logger.new(log_tags) if log_tags
    @record = Image.new do |i|
      i.source_url = url.is_a?(String) ? url : url.to_s
      i.alt        = alt
    end
    yield self if block_given?
  end

  def log_tags=(*tags)
    @logger = Scrape::Logger.new(*tags)
  end

  def to_a
    [self]
  end

  def with_temp_image
    begin
      source_url.is_a?(URI) ? _build_temp_image_from_uri : _build_temp_image_from_url
      yield temp_image.open
    ensure
      temp_image.close
      temp_image.unlink if temp_image.is_a? Tempfile
    end
  end

  def _build_temp_image_from_url
    @temp_image = LocalResource.file_from_url( source_url )
  end

  def _build_temp_image_from_uri
    @temp_image = LocalResource.file_from_uri( source_url )
  end

  def save
    Scrape::ImagePersister.new(self).save
  end

  def save_image_to(other)
    Scrape::ImagePersister.new(self).save_image_to(other)
  end

  def method_missing(method_id, *args)
    if ImageScraper::RECORD_METHODS.include?(method_id.id2name)
      record.send(method_id, *args)
    else
      super
    end
  end
end









  # def _save_image_to(scraper)
  #   scraper.save if scraper.new_record?

  #   with_temp_image do |tmp_img|
  #     record.asset = tmp_img
  #     if !record.valid?
  #       add_log(:error, "Validation errors. ERRORS: #{record.errors.messages} OBJECT: #{record.inspect}")

  #       nil
  #     else
  #       match = false
  #       scraper.record.images.each do |persisted|
  #         if Compare::Images.duplicate?(persisted.asset.path, tmp_img.path)
  #           match = true
  #           if persisted.asset.size < tmp_img.size
  #             persisted.asset = tmp_img
  #             with_logging([:debug, :info], "Update Image:#{persisted.id} with #{record.source_url}") { persisted.save! }

  #             return persisted
  #           end
  #         end
  #       end

  #       if !match
  #         with_logging([:debug, :info], "Add new image to #{scraper.record.class}:#{scraper.record.id} from #{record.source_url}", :id) do
  #           record.save!
  #           scraper.record.images << record

  #           return record
  #         end
  #       end
  #     end
  #   end
  # end

  # def save_image_to(r)
  #   self.record = _save_image_to(r)
  #   self
  # end
# end
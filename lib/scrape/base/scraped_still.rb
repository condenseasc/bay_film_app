# require 'local_resource'
require 'compare'
require 'scrape/logging'
require 'scrape/base/venue_scraper'

class ScrapedStill
  include Scrape::Logging
  
  RECORD_METHODS = %w[id url url= alt alt= image image= persisted? new_record? valid?]

  def method_missing(method_id, *args)
    if ScrapedStill::RECORD_METHODS.include?(method_id.id2name)
      record.send(method_id, *args)
    else
      super
    end
  end

  attr_accessor :record, :temp_image

  def initialize(url=nil, alt:nil)
    @record = Still.new do |s|
      s.url = url.is_a?(String) ? url : url.to_s
      s.alt = alt
    end
    super()
    yield self if block_given?
  end

  def with_temp_image
    begin
      url.is_a?(URI) ? _build_temp_image_from_uri : _build_temp_image_from_url
      yield temp_image.open
    ensure
      temp_image.close
      temp_image.unlink if temp_image.is_a? Tempfile
    end
  end

  def _build_temp_image_from_url
    @temp_image = LocalResource.file_from_url(url)
  end

  def _build_temp_image_from_uri
    @temp_image = LocalResource.file_from_uri(url)
  end

  def _save_still_to(r)
    r.save_record if r.new_record?

    with_temp_image do |tmp_img|
      record.image = tmp_img

      if !record.valid?
        add_log(:error, "Validation errors. ERRORS: #{record.errors.messages} OBJECT: #{record.inspect}")

        nil
      else
        match = false
        r.stills.each do |persisted|
          if Compare::Images.duplicate?(persisted.image.path, tmp_img.path)
            match = true
            if persisted.image.size < tmp_img.size
              persisted.image = tmp_img
              with_logging([:debug, :info], "Update Still:#{persisted.id} with #{record.url}") { persisted.save! }

              return persisted
            end
          end
        end

        if !match
          with_logging([:debug, :info], "Add new still to #{r.class}:#{r.id} from #{record.url}", :id) do
            record.save!
            r.stills << record

            return record
          end
        end
      end
    end
  end

  def save_still_to(r)
    self.record = _save_still_to(r)
    self
  end
end
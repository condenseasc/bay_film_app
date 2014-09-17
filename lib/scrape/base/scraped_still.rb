# require 'local_resource'
require 'compare'
require 'scrape/base/venue_scraper'

class ScrapedStill
  include Scrape::Logging
  
  RECORD_METHODS = %w[id image]


  def method_missing(method_id, *args)
    # if ScrapedStill::SCRAPE_METHODS.include?(method_id.id2name)
    #   nil
    # els
    if ScrapedStill::RECORD_METHODS.include?(method_id.id2name)
      record.send(method_id, *args)
    else
      super
    end
  end

  attr_accessor :url, :alt, :logger, :record, :temp_image

  def initialize(url=nil, alt=nil)
    @url = url
    @alt = alt
    super()
    yield self if block_given?
  end

  def build_record
    @record = Still.new do |s|
      s.url = url.is_a?(String) ? url : url.to_s
      s.alt = alt
    end
  end

  def build_image
    url.is_a?(URI) ? _build_temp_image_from_uri : _build_temp_image_from_url
  end

  def _build_temp_image_from_url
    @temp_image = LocalResource.file_from_url(url)
  end

  def _build_temp_image_from_uri
    @temp_image = LocalResource.file_from_uri(url)
  end


  def create_record
    build_record
    save_record
  end

  def save_record
    begin
      build_image
      record.image = temp_image.open
      record.save!
    ensure
      temp_image.close
      temp_image.unlink if temp_image.is_a? Tempfile
    end
  end

  def save_still_to(r)
    p r.title
    begin
      build_image
      record.image = temp_image.open
      if !record.valid?
        add_log(:error, "Validation errors. ERRORS: #{record.errors.messages} OBJECT: #{record.inspect}")
      elsif r.new_record?
        add_log(:error, "#save_record before adding Stills: #{r.inspect}")
        return
      else
        match = false
        r.stills.each do |p|
          if Compare::Images.duplicate?(p.image.path, temp_image.path)
            match = true
            if p.image.size < temp_image.size
              p.image = temp_image
              
              with_logging([:debug, :info], "Update Still:#{p.id} with #{record.url}") { p.save! }
            end
          end
        end

        if !match
          with_logging([:debug, :info], "Add new still to #{r.class}:#{r.id} from #{record.url}", :id) do
            record.save!
            r.stills << record
          end
        end
      end
    ensure
      temp_image.close
      temp_image.unlink if temp_image.is_a? Tempfile
    end
  end
end
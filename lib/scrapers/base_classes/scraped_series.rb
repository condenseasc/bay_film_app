require 'scrapers/scrape'

class ScrapedSeries
  include Scrape
  # maximal list of scraping methods
  SCRAPE_METHODS = %w[scrape_title scrape_description]
  # maximal list of attributes written by scrapers
  attr_reader :title, :description
  # initialized properties, with venue being provided
  attr_reader :url, :doc, :logger, :venue

  def initialize(url)
    @url = url
    @doc = make_doc url 
    @logger = VenueScraper.logger
  end

  # defined on VenueScraper too...
  def urls(selector)
    find_urls doc, selector
  end

  def scrape
    scrape_title
    scrape_description
    puts title
  end

  def build_record
    Series.new do |s|
      s.title       = title
      s.description = description
      s.venue       = venue
      s.url         = url
    end
  end

  def create_record
    s = Series.new do |s|
      s.title       = title
      s.description = description
      s.venue       = venue
      s.url         = url
    end

    save_record(s)
  end

  def save_record(r)
    if r.valid?
      r.save!
    # elsif 
    else
      logger.invalid_record(r)
      false
    end
  end

  def method_missing(method_id, *args)
    if ScrapedSeries::SCRAPE_METHODS.include?(method_id.id2name)
      nil
    else
      super(*args)
    end
  end
end
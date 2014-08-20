require 'scrapers/scrape'

class ScrapedSeries
  include Scrape
  ATTRIBUTE_METHODS = %w[venue url name scrape_name description scrape_description]

  attr_reader :url, :doc, :logger, :venue, :title, :description

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
      s.title = title
      s.description = description
      s.venue = venue
      s.url = url
    end

    # create!(

    #   title: s.title,
    #   description: s.description,
    #   venue: s.venue,
    #   url: s.url
    # end
  end

  def create_record
    s = Series.new do |s|
      puts "SELFFFFF #{self}"
      puts title
      s.title = title
      s.description = description
      s.venue = venue
      s.url = url
    end

    if s.valid?
      s.save!
    else
      logger.invalid_record(s)
      false
    end
  end


  def save_record
    if valid?
      save!
    else
      logger.invalid_record(self)
      false
    end
  end

  def method_missing(method_id)
    if ScrapedSeries::ATTRIBUTE_METHODS.include?(method_id.id2name)
      nil
    else
      super
    end
  end
end
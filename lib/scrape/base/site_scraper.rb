require 'scrape/base/topic_scraper'
require 'scrape/base/calendar_scraper'
require 'scrape/base/image_scraper'
require 'scrape/noko_doc'

class SiteScraper
  PACIFIC_TIME_ZONE = 'Pacific Time (US & Canada)'

  class << self
    attr_reader :scrapers, :logger

    def inherited(subclass)
      scrapers << subclass
    end
  end

  @scrapers = []

  attr_reader :calendars, :topics

  def initialize(url)
    @url = url
    @doc = Scrape::NokoDoc.new(url).open
  end

  ## The Machinery. Calendar is always processed before Topic. Very important assumption.
  ##
  # OPENING
  def open_pages
    make_calendars
    make_topics
  end

  # SCRAPING
  def scrape
    scrape_calendars
    scrape_topics
  end

  def scrape_calendars
    calendars.each do |c|
      c.scrape
    end
  end

  def scrape_topics
    topics.each do |t|
      t.scrape
    end
  end

  # SAVING
  def save
    save_calendars
    save_topics
  end

  def save_calendars
    calendars.each do |c|
      c.save
    end
  end

  def save_topics
    topics.each do |t|
      t.save
    end
  end
end
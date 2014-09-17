require 'scrape/base/scraped_event'
require 'scrape/base/scraped_series'
require 'scrape/base/scraped_still'
require 'scrape/noko_doc'

class VenueScraper
  PACIFIC_TIME_ZONE = 'Pacific Time (US & Canada)'

  class << self
    attr_reader :child_scrapers, :logger

    def inherited(subclass)
      child_scrapers << subclass
      # subclass.instance_variable_set("@child_scrapers", @child_scrapers)
    end
  end

  @child_scrapers = []

  attr_reader :series, :events

  ## The Machinery. Series is always processed before Event. Very important assumption.
  ##
  # OPENING
  def open_pages
    make_series
    make_events
  end

  # SCRAPING
  def scrape
    scrape_series
    scrape_events
  end

  def scrape_series
    series.each do |s|
      s.scrape
    end
  end

  def scrape_events
    events.each do |e|
      e.scrape
    end
  end

  # SAVING
  def save_records
    save_series
    save_events
  end

  def save_series
    series.each do |s|
      s.save_record_with_associations
    end
  end

  def save_events
    events.each do |e|
      e.save_record_with_associations
    end
  end
end

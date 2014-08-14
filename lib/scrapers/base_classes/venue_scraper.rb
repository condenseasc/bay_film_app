require 'scrape'

class VenueScraper
  include Scrape

  PACIFIC_TIME_ZONE = 'Pacific Time (US & Canada)'

  @child_scrapers = []

  def initialize
    @child_scrapers = []
  end

  class << self
    attr_reader :child_scrapers

    def inherited(subclass)
      child_scrapers << subclass
    end
  end

  def urls(selector)
    find_urls doc, selector
  end

  # an important assumption -> series before events
  def scrape
    scrape_series
    scrape_events
  end

  def save_records
    save_series
    save_events
  end

  def scrape_series
    @series.each do |s|
      s.scrape_title
      s.scrape_description
    end
  end

  def scrape_events
    @events.each do |e|
      e.scrape_title
      e.scrape_description
      e.scrape_show_notes
      e.scrape_show_credits
      e.scrape_admission
      e.scrape_location_notes
      e.scrape_still
    end
  end
end

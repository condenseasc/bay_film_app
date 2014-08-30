require 'scrapers/scrape'
require 'scrapers/scrape_logger'

class VenueScraper
  include Scrape

  PACIFIC_TIME_ZONE = 'Pacific Time (US & Canada)'

  class << self
    attr_reader :child_scrapers, :logger

    def inherited(subclass)
      child_scrapers << subclass
      # subclass.instance_variable_set("@child_scrapers", @child_scrapers)
    end
  end

  @child_scrapers = []
  @logger = ActiveSupport::TaggedLogging.new(Logger.new('log/scrape.log')).extend(ScrapeLogger)

  attr_reader :series, :events

  def urls(selector)
    find_urls doc, selector
  end

  # The Machinery
  def open_pages
    make_series
    make_events
  end

  # an important assumption > series before events
  def scrape
    scrape_series
    scrape_events
    self
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

  def create_records
    create_series
    create_events
  end
  def create_series
    series.each do |s|
      s.create_record
    end
  end

  def create_events
    events.each do |e|
      e.save
    end
  end

  # def scrape_and_save
  #   scrape_and_save_series
  #   scrape_and_save_events
  # end

  # def scrape_and_save_series
  #   series.scrape_and_save
  # end



  # def build_records
  #   build_series_records
  #   build_events_records
  #   self
  # end

  # def save_records
  #   save_series_records
  #   save_events_records
  #   self
  # end

  # Series


  # def build_series_records
  #   @series.map! do |s|
  #     s.build_record
  #   end
  # end

  # def save_series_records
  #   @series.each do |s|
  #     s.save_record
  #   end
  # end


  # Events

  # def build_events_records
  #   @events.map! do |e|
  #     e.build_record
  #   end
  # end

  # def save_events_records
  #   @events.each do |e|
  #     e.save_record
  #   end
  # end
end

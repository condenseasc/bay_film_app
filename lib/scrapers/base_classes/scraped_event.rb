require 'scrapers/scrape'
require 'scrapers/scraped_stills'

class ScrapedEvent
  include Scrape
  include ScrapedStills

  UPDATEABLE_ASSOCIATIONS = [:series]
  ATTRIBUTE_METHODS = %w[ venue url
    title          scrape_title 
    time           scrape_time
    description    scrape_description
    show_notes     scrape_show_notes
    show_credits   scrape_show_credits
    admission      scrape_admission
    location_notes scrape_location_notes
    stills         scrape_stills
  ]

  attr_reader :url, :doc, :logger, :venue, :title, :time, :description, :show_notes, :show_credits, :admission, :location_notes
  attr_writer :venue, :series
  # Taking care only of the simplest case. Overwrite otherwise
  def initialize(url)
    @url = url
    @doc = make_doc url
    @logger = VenueScraper.logger
  end

  def scrape
    scrape_title
    scrape_time
    scrape_description
    scrape_show_notes
    scrape_show_credits
    scrape_admission
    scrape_location_notes
    scrape_stills
    puts title
  end

  # def build_record
  #   e = Event.new do |e|
  #     e.title          = title
  #     e.time           = time
  #     e.description    = description
  #     e.show_notes     = show_notes
  #     e.show_credits   = show_credits
  #     e.admission      = admission
  #     e.location_notes = location_notes
  #     e.venue          = venue
  #     e.series         = series
  #     e.stills         = stills
  #   end
  # end

  def method_missing(method_id)
    if ScrapedEvent::ATTRIBUTE_METHODS.include?(method_id.id2name)
      nil
    else
      super
    end
  end

  # def association_difference(persisted, e)
  #   hash = {}
  #   UPDATEABLE_ASSOCIATIONS.each do |name|
  #     hash[name] = Event.association_difference(persisted, e)
  #     hash.delete(name) if hash[name].empty?
  #   end
  #   hash
  # end


  def create_record
    e = Event.new do |e|
      e.title          = title
      e.time           = time
      e.description    = description
      e.show_notes     = show_notes
      e.show_credits   = show_credits
      e.admission      = admission
      e.location_notes = location_notes
      e.venue          = venue
      e.series         = series
    end
    # I need to add stills after I create events, so I can do all those checks

    e.send.save_scraped_record
    e.send.save_scraped_stills stills
  end


end


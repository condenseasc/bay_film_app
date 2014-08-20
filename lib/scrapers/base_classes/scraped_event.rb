require 'scrapers/scrape'

class ScrapedEvent
  include Scrape
  UPDATEABLE_ASSOCIATIONS = [:series]
  ATTRIBUTE_METHODS = %w[ venue url
    title          scrape_title 
    time           scrape_time
    description    scrape_description
    show_notes     scrape_show_notes
    show_credits   scrape_show_credits
    admission      scrape_admission
    location_notes scrape_location_notes
    still          scrape_still
  ]

  attr_reader :url, :doc, :logger, :venue, :title, :time, :description, :show_notes, :show_credits, :admission, :location_notes, :still
  attr_writer :venue
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
    scrape_still
    puts title
  end

  def build_record
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
      e.still          = still
    end
  end

  #   (
  #     title: title,
  #     description: description,
  #     show_notes: show_notes,
  #     show_credits: show_credits,
  #     admission: admission,
  #     location: location,
  #     venue: venue,
  #     series: series.each { |s| Series.find_by(url: s.url) },
  #     # stills: e.stills
  #   )
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

  def build_record
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
      e.still          = still
    end
  end

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
      e.still          = still
    end

    if e.valid?
      e.save!
      logger.saved_new_record(e)
      return e
    elsif e.errors.size === 1 &&
      e.errors[:title][0] === "already exists at this screening time and venue"
      # Paranoid? Checking if something screwy led to duplicate persisted records.
      # Maybe split this into a different rake task with teeth to check and delete them?
      persisted_events = Event.where(title: e.title, time: e.time, venue: e.venue)
      if persisted_events.length > 1
        logger.multiple_duplicates_found(e)
        raise DuplicateRecordError.new, "Multiple duplicate records for event"
      else
        persisted = persisted_events[0]
      end
      # Get a hash of attributes and a hash of :association => [records]
      attributes = Event.attribute_difference(persisted, e)
      hash = {}
      UPDATEABLE_ASSOCIATIONS.each do |name|
        hash[name] = Event.association_difference(persisted.send(name), e.send(name))
        hash.delete(name) if hash[name].empty?
      end
      associations = hash
      # Update only if there's a difference. Note: this test prunes the associations hash
      if attributes.empty? && associations.empty?
        logger.identical_to(persisted)
        return persisted
      else
        logger.update_record(e, attributes, associations)
        associations.each { |key, value| persisted.send(key) << value } unless associations.empty?
        if persisted.update!(attributes) then persisted else false end
      end
    else
      logger.invalid_record(e)
      return nil
    end
  end
end


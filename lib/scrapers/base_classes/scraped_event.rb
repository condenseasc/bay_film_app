require 'scrapers/scrape'
require 'scrapers/base_classes/scraped_still'
require 'local_resource'
require 'compare'


class ScrapedEvent
  include Scrape
  # include ScrapedStills

  UPDATEABLE_ASSOCIATIONS = [:series]
  ATTRIBUTE_METHODS = %w[
    scrape_title 
    scrape_time
    scrape_description
    scrape_show_notes
    scrape_show_credits
    scrape_admission
    scrape_location_notes
    scrape_stills
  ]
  attr_reader :title, 
              :time, 
              :description, 
              :show_notes, 
              :show_credits, 
              :admission, 
              :location_notes,
              :stills

  attr_reader :url, :doc, :logger, :venue
  # attr_writer :venue, :series
  # Taking care only of the simplest case. Overwrite otherwise
  def initialize(url)
    @url = url
    @doc = make_doc url
    @logger = VenueScraper.logger
  end

  # series by title at venue is guaranteed to be unique
  # ScrapedEvent and ScrapedSeries should be able to use
  # Series objects independently. They may be updated, but not removed.
  # Here again, ScrapedSeries have to be processed first.
  def series
    @series_records ||= @series.map { |s| Series.find_by(title: s.title, venue: s.venue) }
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
      e.series = series unless series.empty?
    end

    # I need to add stills after I create events, so I can do all those checks
    # because 'those checks' are tied to the event itself, which stills it already holds
    save_scraped_record(e)
    stills.each { |s| s.save_still_to(e) }
    # ScrapedStill.save_stills(e, stills)
    # e.send.save_scraped_stills stills
  end

  def method_missing(method_id)
    if ScrapedEvent::ATTRIBUTE_METHODS.include?(method_id.id2name)
      nil
    else
      super
    end
  end

  # valid?
  # # save
  # elsif duplicate
  # # check for multiple duplicates (error!)
  # # check for and makes updates
  # else
  # # invalid, logs errors
  def save_scraped_record(r)
    if r.valid?
      r.save!
      logger.saved_new_record(r)
      return r
    elsif r.errors.size == 1 && r.errors[:title][0] == "already exists at this screening time and venue"
      # Paranoid? Checking if something screwy led to duplicate persisted records.
      # Maybe split this into a different rake task with teeth to check and delete them?
      persisted_events = Event.where(title: r.title, time: r.time, venue: r.venue)
      if persisted_events.length > 1
        logger.multiple_duplicates_found(r)
        raise DuplicateRecordError.new, "Multiple duplicate records for event"
      else
        persisted = persisted_events[0]
      end
      # Get a hash of attributes and a hash of :association => [records]
      attributes = Compare::Records.attribute_difference(persisted, r, Compare::Records::EVENT_EXCLUSIONS)
      hash = {}
      UPDATEABLE_ASSOCIATIONS.each do |name|
        hash[name] = Compare::Records.association_difference(persisted.send(name), r.send(name))
        hash.delete(name) if hash[name].empty?
      end
      associations = hash
      # Update only if there's a difference. Note: this test prunes the associations hash
      if attributes.empty? && associations.empty?
        logger.identical_to(persisted)
        return persisted
      else
        logger.update_record(r, attributes, associations)
        associations.each { |key, value| persisted.send(key) << value } unless associations.empty?
        if persisted.update!(attributes) then persisted else false end
      end
    else
      logger.invalid_record(r)
      return nil
    end
  end

end


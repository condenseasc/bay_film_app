require 'scrapers/scrape'
require 'scrapers/base_classes/scraped_still'
require 'local_resource'
require 'compare'

class ScrapedEvent
  include Scrape
  include Compare::Records

  UPDATEABLE_ASSOCIATIONS = [:series]
  SCRAPE_METHODS = %w[
    scrape_title
    scrape_time
    scrape_description
    scrape_show_notes
    scrape_show_credits
    scrape_admission
    scrape_location_notes
    scrape_stills
  ]

  EVENT_METHODS = %w[
    title           title=
    time            time=
    description     description=
    show_notes      show_notes=
    show_credits    show_credits=
    location_notes  location_notes=
    created_at
    updated_at      
    persisted?
    new_record?
  ]

  attr_reader :event, :stills
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
    if @series && @series.is_a?(Enumerable) && !@series.empty?
      @series.map { |s| s.series unless s.series.new_record? }
    elsif @series.series.class == Series
      @series.series
    else
      false
    end

    #   { |s| Series.find_by(title: s.title, venue: s.venue) }
    # end
  end

  def scrape
    @event = Event.new

    event.title           = scrape_title
    event.time            = scrape_time
    event.description     = scrape_description
    event.show_notes      = scrape_show_notes
    event.show_credits    = scrape_show_credits
    event.admission       = scrape_admission
    event.location_notes  = scrape_location_notes
    event.venue   = venue
    if series then event.series = series end

    # event.series  = series unless !series
    
    @stills = scrape_stills
    puts title
  end

  def save
    event = save_record
    if event && stills && !stills.empty? 
      stills.each { |s| s.save_still_to(event) }
    end
  end

  def method_missing(method_id, *args)
    if ScrapedEvent::SCRAPE_METHODS.include?(method_id.id2name)
      nil
    elsif ScrapedEvent::EVENT_METHODS.include?(method_id.id2name)
      event.send(method_id, *args)
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
  def save_record
    if event.valid?
      event.save!
      logger.saved_new_record(event)
      return event
    elsif event.errors.size == 1 && event.errors[:title][0] == "already exists at this screening time and venue"
      # Paranoid? Checking if something screwy led to duplicate persisted records.
      # Maybe split this into a different rake task with teeth to check and delete them?
      persisted_events = Event.where(title: event.title, time: event.time, venue: event.venue)
      if persisted_events.length > 1
        logger.multiple_duplicates_found(event)
        raise DuplicateRecordError.new, "Multiple duplicate records for event"
      else
        persisted = persisted_events[0]
      end
      # Get a hash of attributes and a hash of :association => [records]
      attributes = attribute_difference(persisted, event, Compare::Records::EVENT_EXCLUSIONS)
      hash = {}
      UPDATEABLE_ASSOCIATIONS.each do |name|
        hash[name] = association_difference(persisted.send(name), event.send(name))
        hash.delete(name) if hash[name].empty?
      end
      associations = hash
      # Update only if there's a difference. Note: this test prunes the associations hash
      if attributes.empty? && associations.empty?
        logger.identical_to(persisted)
        return persisted
      else
        logger.update_record(event, attributes, associations)
        associations.each { |key, value| persisted.send(key) << value } unless associations.empty?
        if persisted.update!(attributes) then persisted else false end
      end
    else
      logger.invalid_record(event)
      return nil
    end
  end

end
# (eval "Compare::Records::#{r.class.to_s.upcase}_EXCLUSIONS")

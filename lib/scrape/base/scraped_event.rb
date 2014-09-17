require 'scrape/saving'
require 'scrape/noko_doc'
require 'scrape/logging'


class ScrapedEvent
  include Scrape::Saving::Stills
  extend  Scrape::Saving

  SCRAPE_METHODS = %w[
    scrape_title
    scrape_time
    scrape_description
    scrape_announcement
    scrape_short_credit
    scrape_full_credits
    scrape_admission
    scrape_location_note
    scrape_stills
  ]

  EVENT_METHODS = %w[
    title           title=
    time            time=
    description     description=
    announcement    announcement=
    short_credit    short_credit=
    location_note   location_note=
    created_at
    updated_at      
    persisted?
    new_record?
    id
  ]

  # precisely order dependent! matches how it's listed in the Event class
  save_or_update_using_identity_attributes :title, :time, :venue

  attr_accessor :record
  attr_accessor :series
  attr_reader :stills, :url, :doc, :venue
  def initialize(url, path: nil)
    @url = url
    @doc = Scrape::NokoDoc.new(url, path: path).open_doc
    super()
  end

  def scrape
    @record = Event.new
    # separate #tap because some scrape methods need to directly call accessors on Event
    record.tap do |e|
      e.title           = scrape_title
      e.time            = scrape_time
      e.description     = scrape_description
      e.announcement    = scrape_announcement
      e.short_credit    = scrape_short_credit
      e.full_credits    = scrape_full_credits
      e.admission       = scrape_admission
      e.location_note   = scrape_location_note
      e.venue           = venue
    end
    
    @stills = scrape_stills
    puts title
  end

  def save_record_with_associations
    record = save_record
    save_stills
    save_series
  end

  def method_missing(method_id, *args)
    if ScrapedEvent::SCRAPE_METHODS.include?(method_id.id2name)
      nil
    elsif ScrapedEvent::EVENT_METHODS.include?(method_id.id2name)
      record.send(method_id, *args)
    else
      super
    end
  end

  def save_series
    if series
      self.series = self.series.compact.map { |s| s.save_record }
      series.compact!
      
      unless series.empty?
        with_logging([:debug, :info], "Add Series#{series.inject { |str, r| str + ' ' + (r.id || r.title) }} to Event:#{record.id}") do
          record.series << series
        end
      end
    end
  end




#     if series && series.is_a?(Enumerable) && !series.compact.empty? && series.compact.first.is_a?(ScrapedSeries)
#       series.map { |s| s.save_record }        # get the persisted copies of each, inverse_of doesn't work here
#     elsif series && series.is_a?(ScrapedSeries)
#       series.save_record
#       series = [series]
#       # series = [series.save_record]
#     else
#       return false
#     end

# # issue here is, I'm not sure exactly what issues I'm filtering out; maybe come back with better logging
#     if series && series.keep_if {|s| s.responds_to? :record} 
#       series_array = series.map { |s| s.record }          # strip them to records
#       series_array.select!      { |s| s.class == Series } # keep only records
#       with_logging([:debug, :info], "Add Series#{series_array.inject { |str, r| str + ' ' + (r.id || r.title) }} to Event:#{record.id}") do
#         record.series << series_array unless series_array.empty?
#       end
#     end
#   end
end
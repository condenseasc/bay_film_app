require 'scrape/saving'
require 'scrape/noko_doc'
require 'scrape/logging'


class ScrapedEvent
  include Scrape::Saving::Stills
  extend  Scrape::Saving

  SCRAPE_METHODS = %w[
    scrape_title
    scrape_supertitle
    scrape_supertitle
    scrape_callout
    scrape_body
    scrape_footer
    scrape_admission

    scrape_times
    scrape_site
    scrape_stills
  ]

  EVENT_METHODS = %w[
    title       title=
    supertitle  supertitle=
    subtitle    subtitle=
    callout     callout=
    body        body=
    footer      footer=
    url         url=
    admission   admission=
    event_times event_times=
    times       times=
    created_at
    updated_at      
    persisted?
    new_record?
    valid?
    id
  ]

  # precisely order dependent! matches how it's listed in the Event class
  save_or_update_using_identity_attributes :title, :venue

  attr_accessor :record, :series
  attr_reader :stills, :url, :doc, :venue
  def initialize(url, series:nil, path:nil)
    @url = url
    @doc = Scrape::NokoDoc.new(url, path: path)
    @series = series
    super()
  end

  def scrape
    doc.open
    @record = Event.new
    # separate #tap because some scrape methods need to directly call accessors on Event
    record.tap do |e|
      e.title       = scrape_title
      e.supertitle  = scrape_supertitle
      e.subtitle    = scrape_supertitle
      e.callout     = scrape_callout
      e.body        = scrape_body
      e.footer      = scrape_footer
      e.admission   = scrape_admission
      e.event_times << make_event_times
      # e.location_note   = scrape_location_note
      e.venue       = venue

    end
    # @site   = scrape_site
    # @time   = scrape_times
    @stills = scrape_stills
    puts title
    self
  end

  def make_event_times
    [scrape_times].flatten.map { |t| e = EventTime.new(start: t); puts e.inspect; e }
  end

  def save_record_with_associations
    save_record
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

  def save_events


  end

  def save_series
    if series
      # Don't pollute logs from test
      tags = log_tags
      test_tags = tags.include?(:test) ? ->(x){ x.log_tags.unshift(*tags); x } : ->(x){x}
      # Make sure we have only non-nil persisted records, in an ARRAY
      # s = series.respond_to?(:each) ? series : [s]
      # Doesn't make sense, I can't call test_tags on an array.
      # series = test_tags.call( s.compact ).map(&:save_record).compact
      series = Array(series).each { |s| test_tags.call(s) }.map(&:save_record).compact

      # #### Detritus
      # if series.respond_to?(:each)
      #   test_tags.call(series.compact).each(&:save_record)
      # else
      #   test_tags.call([series].compact).each(&:save_record)
      # self.series = self.series.compact.map { |s| s.save_record }
      # if log_tags.include?(:test) then series.each { |s| s.log_tags.unshift(*log_tags) } end
      # if series.respond_to?(:each)
      #   series = series.compact.each(&:save_record).compact
      # else
      #   series = [series.save_record].compact
      # end
      # series = series.respond_to?(:each) ? series.compact.each(&:save_record).compact : [series.save_record].compact
      # series = series.respond_to?(:each) ? series.compact : [series].compact
      # ####

      unless series.empty?
        with_logging([:debug, :info], "Add Series#{series.inject { |str, r| str + ' ' + (r.id || r.title) }} to Event:#{record.id}") do
          record.series << series.map(&:record).compact
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
#     if series && series.keep_if {|s| s.respond_to? :record} 
#       series_array = series.map { |s| s.record }          # strip them to records
#       series_array.select!      { |s| s.class == Series } # keep only records
#       with_logging([:debug, :info], "Add Series#{series_array.inject { |str, r| str + ' ' + (r.id || r.title) }} to Event:#{record.id}") do
#         record.series << series_array unless series_array.empty?
#       end
#     end
#   end
end
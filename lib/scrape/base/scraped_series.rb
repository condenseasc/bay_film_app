# require 'compare'
require 'scrape/saving'
require 'scrape/noko_doc'
# require 'scrape/logging'

class ScrapedSeries
  # include Compare::Records
  # include Scrape
  # extend Scrape::Saving
  # include Scrape::NokoDocs
  # include Scrape::Logging
  # extend Scrape::Saving

  # include Scrape::NokoDocs
  include Scrape::Saving::Stills
  extend  Scrape::Saving



  SCRAPE_METHODS = %w[scrape_title 
                      scrape_body
                      scrape_stills]  # maximal list of scraping methods

  # SERIES_METHODS = %w[title 
  #                     description 
  #                     id 
  #                     persisted? 
  #                     new_record? 
  #                     created_at 
  #                     updated_at]                # maximal list of attributes written by scrapers

  SERIES_METHODS = %w[
    title       title=
    supertitle  supertitle=
    subtitle    subtitle=
    callout     callout=
    body        body=
    footer      footer=
    url         url=
    created_at
    updated_at      
    persisted?
    new_record?
    valid?
    id
  ]


  attr_reader :url, :doc, :venue
  attr_accessor :record

  save_or_update_using_identity_attributes :title, :venue

  # initialize_saving(:title, :venue)

  def initialize(url, path:nil)
    @url = url
    @doc = Scrape::NokoDoc.new(url, path:path)
    super()
  end

  def scrape
    doc.open
    @record = Series.new do |s|
      s.title = scrape_title
      s.body = scrape_body
      s.venue = venue
      s.url = url
    end
    @stills = scrape_stills # not yet an attribute on series
    puts title
    self
  end

  def save_record_with_associations
    save_record
    # record = save_record
  end

  def method_missing(method_id, *args)
    if ScrapedSeries::SCRAPE_METHODS.include?(method_id.id2name)
      nil
    elsif ScrapedSeries::SERIES_METHODS.include?(method_id.id2name)
      record.send(method_id, *args)
    else
      super
    end
  end
end
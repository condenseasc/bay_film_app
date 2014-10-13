# require 'compare'
require 'scrape/saving'
require 'scrape/noko_doc'
require 'scrape/base/calendar_persister'
require 'scrape/logger'

class CalendarScraper
  extend Forwardable

  SCRAPE_METHODS = %w[
    scrape_title
    scrape_supertitle
    scrape_subtitle
    scrape_callout
    scrape_body
    scrape_footer
  ]

  def initialize(url, path:nil, log_tags:nil)
    @url = url
    @doc = Scrape::NokoDoc.new(url, path:path)
    @logger = Scrape::Logger.new(log_tags) if log_tags 
  end

  attr_reader :url, :doc, :image_scrapers
  attr_accessor :record, :logger

  def_delegators :@record,    :title,   :title=,     :supertitle, :supertitle=,
    :subtitle,   :subtitle=,  :callout, :callout=,   :body,       :body=, 
    :footer,     :footer=,
    :images,     :images=,
    :created_at, :updated_at, :id,      :persisted?, :new_record?, :valid?


  def log_tags=(*tags)
    @logger = Scrape::Logger.new(*tags)
  end

  def log_tags
    logger.log_tags
  end

  def image_scrapers=(imgs)
    @image_scrapers = imgs.select { |i| i.kind_of? ImageScraper }
  end

  def scrape_images
    []
  end

  def scrape(after:nil)
    doc.open
    @record = Calendar.new do |c|
      c.title       = scrape_title
      c.supertitle  = scrape_supertitle
      c.subtitle    = scrape_subtitle
      c.callout     = scrape_callout
      c.body        = scrape_body
      c.footer      = scrape_footer
      c.url         = @url
      c.scraped     = true
    end
    
    @image_scrapers = scrape_images # not yet an attribute on series
    puts title

    self.save if after == :save
    self
  end

  def save
    Scrape::CalendarPersister.new(self).save
  end

  def method_missing(method_id, *args)
    if CalendarScraper::SCRAPE_METHODS.include?(method_id.id2name)
      nil
    else
      super
    end
  end
end
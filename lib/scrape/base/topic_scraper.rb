require 'scrape/saving'
require 'scrape/noko_doc'
require 'scrape/logger'
require 'scrape/base/topic_persister'

class TopicScraper
  extend Forwardable

  SCRAPE_METHODS = %w[
    scrape_title
    scrape_supertitle
    scrape_subtitle
    scrape_callout
    scrape_body
    scrape_footer

    scrape_times
    scrape_site
  ]

  def_delegators :@record,    :title,   :title=,     :supertitle, :supertitle=,
    :subtitle,   :subtitle=,  :callout, :callout=,   :body,       :body=, 
    :footer,     :footer=,    :url,     :url=,     
    :events,     :events=,
    :created_at, :updated_at, :id,      :persisted?, :new_record?, :valid?
  attr_accessor :record, :logger
  attr_reader :url, :doc, :venue, :calendar_scraper, :image_scrapers

  def initialize(url, calendar_scraper:nil, path:nil, log_tags:nil)
    @url = url
    @doc = Scrape::NokoDoc.new(url, path: path)
    @logger = Scrape::Logger.new(log_tags) if log_tags
    self.calendar_scraper = calendar_scraper
  end

  def scrape_images
    []
  end

  def calendar_scraper=(cal)
    @calendar_scraper = cal if cal.kind_of? CalendarScraper
  end

  def image_scrapers=(imgs)
    @image_scrapers = imgs.select { |i| i.kind_of? ImageScraper }
  end

  def log_tags=(*tags)
    @logger ||= Scrape::Logger.new
    logger.log_tags.concat [tags.flatten]
  end

  def log_tags
    @logger.log_tags
  end

  def scrape(after:nil)
    doc.open
    @record = Topic.new
    record.tap do |t|
      t.title       = scrape_title
      t.supertitle  = scrape_supertitle
      t.subtitle    = scrape_subtitle
      t.callout     = scrape_callout
      t.body        = scrape_body
      t.footer      = scrape_footer
      t.events      << make_events
      t.scraped     = true
    end
    @image_scrapers = scrape_images
    puts title

    self.save if after == :save
    self
  end

  def to_a
    [self]
  end

  def make_events
    #admission?
    [scrape_times].flatten.map { |t| Event.new(time: t, venue: venue) }
  end

  def method_missing(method_id, *args)
    if TopicScraper::SCRAPE_METHODS.include?(method_id.id2name)
      nil
    else
      super
    end
  end

  def save
    Scrape::TopicPersister.new(self).save
  end
end
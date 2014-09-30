require 'scrape/base/scraped_event'
require 'scrape/ybca/ybca_scraper'
require 'scrape/helpers'

class YbcaEvent < ScrapedEvent
  extend Scrape::Helpers

  SUPERTITLE = ".field-name-field-supertitle"
  TITLE = ".program-field-main-title"
  SHORT_CREDIT = ".program-field-subtitle" #SUBTITLE
  LOCATION_NOTE = ".program-venue-panel-pane span a:first-child" # it's a link, so use href too #LOCATION || Location text and url
  TIME = ".pane-node-field-performance-times .date-display-single"
  DESCRIPTION = ".panel-pane-program-overview .body" #TEXT

  ANNOUNCEMENT = '.field-name-field-pullquote' #CALLOUT

  @venue = Venue.find_or_create_by(name: YbcaScraper::VENUE_NAME)
  class << self
    attr_reader :venue
  end

  def initialize(url, series:nil, path:nil)
    super
    @venue = YbcaEvent.venue
  end

  scrape_text :title, :short_credit
  scrape_inner_html :description

  # implementation needs to catch up with EventCapsules
  def scrape_time
    Time.zone = "Pacific Time (US & Canada)"
    doc.css(YbcaEvent::TIME).map { |n| Time.zone.parse( n.text ) }
  end



  def scrape_call_out
  end
end
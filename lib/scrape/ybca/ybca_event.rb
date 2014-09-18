require 'scrape/base/scraped_event'
require 'scrape/ybca/ybca_scraper'

class YbcaEvent < ScrapedEvent

  @venue = Venue.find_or_create_by(name: YbcaScraper::VENUE_NAME)
  class << self
    attr_reader :venue
  end

  def initialize(url, series:nil, path:nil)
    super
    @venue = YbcaEvent.venue
  end
end
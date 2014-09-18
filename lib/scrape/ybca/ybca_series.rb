require 'scrape/base/scraped_series'
require 'scrape/ybca/ybca_scraper'

class YbcaSeries < ScrapedSeries
  @venue = Venue.find_or_create_by(name: YbcaScraper::VENUE_NAME)
  class << self
    attr_reader :venue
  end

  def initialize(url, path:nil)
    super
    @venue = YbcaSeries.venue
  end
end
require 'scrape/base/scraped_series'
require 'scrape/pfa/pfa_scraper'

class PfaSeries < ScrapedSeries

  class << self
    attr_reader :venue
  end
  @venue = Venue.find_or_create_by(name: PfaScraper::VENUE_NAME)

  def initialize(url, path:nil)
    super
    @venue = PfaSeries.venue
  end

  def scrape_title
    @title = doc.css(PfaScraper::SERIES_TITLE_SELECTOR).text.strip
  end

  def scrape_body
    @body = doc.css(PfaScraper::SERIES_BODY).inner_html
  end

  def make_events_from_series
    event_urls = doc.find_urls(PfaScraper::SERIES_EVENT_LINK_SELECTOR).uniq
    event_urls.delete_if { |url| url !~ %r'/film/' }
    event_urls.map { |url| puts url; PfaEvent.new(url, series:[self])}
  end
end
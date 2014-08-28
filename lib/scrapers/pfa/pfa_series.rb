class PfaSeries < ScrapedSeries

  class << self
    attr_reader :venue
  end

  def initialize(url)
    super
    @venue = Venue.find_or_create_by(name: PfaScraper::VENUE_NAME)
  end

  def scrape_title
    @title = doc.css(PfaScraper::SERIES_TITLE_SELECTOR).text.strip
  end

  def scrape_description
    @description = doc.css(PfaScraper::SERIES_DESCRIPTION).inner_html
  end

  def make_events_from_series
    event_urls = urls(PfaScraper::SERIES_EVENT_LINK_SELECTOR).uniq
    event_urls.delete_if { |url| url !~ %r'/film/' }
    event_urls.map { |url| puts url; PfaEvent.new(url, self)}
  end
end
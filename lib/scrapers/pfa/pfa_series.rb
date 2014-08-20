class PfaSeries < ScrapedSeries
  def initialize(url)
    super
    @venue = PfaScraper.venue
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
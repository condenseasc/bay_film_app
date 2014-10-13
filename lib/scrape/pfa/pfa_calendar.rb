require 'scrape/base/calendar_scraper'
require 'scrape/pfa/pfa_scraper'

class PfaCalendar < CalendarScraper

  class << self
    attr_reader :venue
  end
  @venue = Venue.find_or_create_by(name: PfaScraper::VENUE_NAME)

  def initialize(url, **args)
    super
    @venue = PfaCalendar.venue
  end

  def scrape_title
    @title = doc.css(PfaScraper::CALENDAR_TITLE_SELECTOR).text.strip
  end

  def scrape_body
    @body = doc.css(PfaScraper::CALENDAR_BODY).inner_html
  end

  def make_topics_from_calendar
    event_urls = doc.find_urls(PfaScraper::CALENDAR_TOPIC_LINK_SELECTOR).uniq
    event_urls.delete_if { |url| url !~ %r'/film/' }
    event_urls.map { |url| puts url; PfaTopic.new( url, calendar_scraper:self )}
  end
end
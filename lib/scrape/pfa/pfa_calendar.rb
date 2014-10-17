require 'scrape/base/calendar_scraper'
require 'scrape/pfa/pfa_topic'
require 'scrape/helpers'

class PfaCalendar < CalendarScraper
  extend Scrape::Helpers

  TITLE       = 'h2'
  BODY        = 'p:nth-child(6)'
  TOPIC_LINK  = 'p a'
  IMAGES      = '.media img'

  scrape_text :title
  scrape_inner_html :body
  use_scrape_images

  def venue
    @venue ||= Venue.find_by(name: 'Pacific Film Archive Theater')
  end

  def make_topics_from_calendar
    event_urls = doc.open.find_urls(PfaCalendar::TOPIC_LINK).uniq
    event_urls.delete_if { |url| url !~ %r'/film/' }
    event_urls.map { |url| puts url; PfaTopic.new( url, calendar_scraper:self )}
  end
end
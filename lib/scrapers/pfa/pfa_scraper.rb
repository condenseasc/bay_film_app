class PfaScraper < VenueScraper
  HOME_URL = "http://www.bampfa.berkeley.edu/filmseries/"
  HOME_SERIES_LINK_SELECTOR = ".textblack a"

  SERIES_TITLE_SELECTOR = 'h2'
  SERIES_DESCRIPTION = 'p:nth-child(6)'
  SERIES_EVENT_LINK_SELECTOR = 'p a'

  EVENT_TITLE = "#sub_maintext span"
  EVENT_DATE = ".sub_wrapper div:nth-child(3)"
  EVENT_TIME = ".sub_wrapper tr:nth-child(1) td:nth-child(1)"
  EVENT_DATE_NO_IMG = "#sub_maintext div+ div"
  EVENT_TEXT_BLOB = ".sub_wrapper p"
  EVENT_SHOW_CREDITS = ".sub_wrapper tr:nth-child(1) td:nth-child(2)" #minus the title
  EVENT_IMG = ".media img"

  attr_accessor :doc, :url, :series, :events

  def initialize
    @url = HOME_URL
    @doc = make_doc( url )
    @series = []
    @events = []
  end

  def make_series
    series_urls = urls(PfaScraper::HOME_SERIES_LINK_SELECTOR).uniq
    series_urls.delete_if {|u| u !~ %r'/filmseries/'}
    series_urls.each { |url| @series.push PfaSeries.new(url) }
  end

  def make_events
    @series.each { |s| @events.concat s.make_events_from_series }
  end
end

# load 'lib/scrapers/base_classes/venue_scraper.rb'
# load 'lib/scrapers/base_classes/scraped_series.rb'
# load 'lib/scrapers/base_classes/scraped_event.rb'
# load 'lib/scrapers/pfa/pfa_scraper.rb'
# load 'lib/scrapers/pfa/pfa_series.rb'
# load 'lib/scrapers/pfa/pfa_event.rb'


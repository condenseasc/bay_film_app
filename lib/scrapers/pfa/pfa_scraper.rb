class PfaScraper < VenueScraper
  VENUE_NAME = 'Pacific Film Archive Theater'
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

  class << self
    attr_reader :logger
    # :venue
  end
  # had to take this out because Rake uses this class to generate tasks...
  # at which point it hasn't yet loaded the environment :(
  # @venue = Venue.find_or_create_by(name: 'Pacific Film Archive Theater')

  attr_reader :doc, :url, :venue

  def initialize(uri = PfaScraper::HOME_URL)
    @url = uri
    @doc = make_doc( url )
    @venue = PfaScraper.venue
  end

  def make_series
    if series
      series
    else
      @series = []
      series_urls = urls(PfaScraper::HOME_SERIES_LINK_SELECTOR).uniq
      series_urls.delete_if {|u| u !~ %r'/filmseries/'}
      series_urls.each do |url| 
        @series.push PfaSeries.new(url)
        puts url
      end
      # series # annoying, not worth it for now
    end
  end

  def make_events
    if events
      events
    else
      @events = []
      @series.each do |s| 
        e = s.make_events_from_series
        @events.concat e
        # e.each(&:title) #Something to look at while it's running!
        # events
      end
    end
  end
end

# load 'lib/scrapers/scrape_logger.rb'
# load 'lib/scrapers/scrape.rb'
# load 'lib/scrapers/base_classes/venue_scraper.rb'
# load 'lib/scrapers/pfa/pfa_scraper.rb'
# load 'lib/scrapers/base_classes/scraped_series.rb'
# load 'lib/scrapers/base_classes/scraped_event.rb'
# load 'lib/scrapers/pfa/pfa_series.rb'
# load 'lib/scrapers/pfa/pfa_event.rb'
# load 'lib/scrapers/scraped_stills.rb'
# load 'lib/local_resource.rb'
# load 'lib/compare.rb'


require 'scrape/noko_doc'
require 'scrape/base/venue_scraper'

class YbcaScraper < VenueScraper
  VENUE_NAME = "Yerba Buena Center for the Arts"
  LAST_EVENT_PAGE = '.arrow.last a'
  YBCA_URL = "http://www.ybca.org/programs/upcoming/film-and-video"
  HOME_SERIES_LINK = ".views-field-field-key-program-cluster a"
  HOME_EVENT_LINK = ".upcoming-programs-content-pane .views-field-title a"
  SERIES_EVENT_LINK = ".views-field-field-mini-program-1 a"

  PULL_QUOTE = '.field-name-field-pullquote'

  attr_accessor :series, :events, :doc, :url, :series_urls, :series_events, :bare_events

  def initialize(url=YbcaScraper::YBCA_URL)
    @url = url
    @doc = Scrape::NokoDoc.new(url).open
    @series = []
    @events = []
    @series_urls = []
    @event_urls = []
    # @event_in_series_url = []
  end

  # find_series_urls

  # find_event_urls

  # def open_series
  # end

  # def open_events
  # end

  def make_series
    return true if ( !series.empty? && series.first.is_a?(YbcaSeries) )

    last_page_url = URI.parse(doc.css(YbcaScraper::LAST_EVENT_PAGE).attr('href').value)
    number_of_pages = CGI.parse(last_page_url.query)['page'].pop.to_i
    url_array = [url]

    (1..number_of_pages).each do |n|
      url_array.push( URI::HTTP.build(
        host: URI(YbcaScraper::YBCA_URL).host, 
        path: last_page_url.path, 
        query: {page: n}.to_param).to_s
      )
    end

    url_array.each do |url|
      doc = Scrape::NokoDoc.new(url).open
      @series_urls.concat doc.find_urls(YbcaScraper::HOME_SERIES_LINK)
      @event_urls.concat  doc.find_urls(YbcaScraper::HOME_EVENT_LINK)
      @event_urls.uniq!
    end

    @series_urls.uniq.each { |url| @series.push YbcaSeries.new(url) }
    true
  end

  def make_events
    return true if ( !events.empty? && events.first.is_a?(YbcaEvent) )

    @series.each do |series|
      series.doc.open.find_urls( YbcaScraper::SERIES_EVENT_LINK ).each do |event_url|
        print event_url
        @event_urls.delete( event_url )
        @events.push YbcaEvent.new( event_url, series:[series] )
        puts " opened"
      end
    end

    puts 'done with series events. moving to seriesless'

    @event_urls.each { |event_url| print event_url; @events.push YbcaEvent.new(event_url); puts " Opened" }
    true
  end
end


# two strategies. One is to create the documents but without opening them!!!
# the other is to just use urls. put that off to scrape.


# load 'lib/local_resource.rb'
# load 'lib/compare.rb'
# load 'lib/scrape/logging.rb'
# load 'lib/scrape/noko_doc.rb'

# load 'lib/scrape/base/venue_scraper.rb'
# load 'lib/scrape/ybca/ybca_scraper.rb'

# load 'lib/scrape/base/scraped_series.rb'
# load 'lib/scrape/base/scraped_still.rb'
# load 'lib/scrape/base/scraped_event.rb'
# load 'lib/scrape/ybca/ybca_series.rb'
# load 'lib/scrape/ybca/ybca_event.rb'

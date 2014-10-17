require 'scrape/noko_doc'
require 'scrape/base/site_scraper'

class YbcaScraper < SiteScraper
  VENUE_NAME = "Yerba Buena Center for the Arts"
  LAST_TOPIC_PAGE = '.arrow.last a'
  YBCA_URL = "http://www.ybca.org/programs/upcoming/film-and-video"
  HOME_CALENDAR_LINK = ".views-field-field-key-program-cluster a"
  HOME_TOPIC_LINK = ".upcoming-programs-content-pane .views-field-title a"
  CALENDAR_TOPIC_LINK = ".views-field-field-mini-program-1 a"

  attr_accessor :calendar, :topics, :doc, :url

  def initialize(url=YbcaScraper::YBCA_URL)
    super
    @calendars = []
    @topics = []
    @calendar_urls = []
    @topic_urls = []
  end

  def make_calendars
    return true if ( !calendars.empty? && calendars.first.is_a?(YbcaCalendar) )

    last_page_url = URI.parse(doc.css(YbcaScraper::LAST_TOPIC_PAGE).attr('href').value)
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
      @calendar_urls.concat doc.find_urls(YbcaScraper::HOME_CALENDAR_LINK)
      @topic_urls.concat  doc.find_urls(YbcaScraper::HOME_TOPIC_LINK)
      @topic_urls.uniq!
    end

    @calendar_urls.uniq.each { |url| @calendars.push YbcaCalendar.new(url) }
    true
  end

  def make_topics
    return true if ( !topics.empty? && topics.first.is_a?(YbcaTopic) )

    @calendars.each do |calendar|
      calendar.doc.open.find_urls( YbcaScraper::CALENDAR_TOPIC_LINK ).each do |topic_url|
        print topic_url
        @topic_urls.delete( topic_url )
        @topics.push YbcaTopic.new( topic_url, calendar_scraper:calendar )
        puts " opened"
      end
    end

    puts 'done with calendar topics. moving to calendarless'

    @topic_urls.each { |topic_url| print topic_url; @topics.push YbcaTopic.new(topic_url); puts " Opened" }
    true
  end
end
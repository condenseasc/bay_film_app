require 'scrape/base/site_scraper'
require 'scrape/noko_doc'

class PfaScraper < SiteScraper
  VENUE_NAME = 'Pacific Film Archive Theater'
  HOME_URL = "http://www.bampfa.berkeley.edu/filmseries/"
  HOME_CALENDAR_LINK_SELECTOR = ".textblack a"

  CALENDAR_TITLE_SELECTOR = 'h2'
  CALENDAR_BODY = 'p:nth-child(6)'
  CALENDAR_TOPIC_LINK_SELECTOR = 'p a'

  TOPIC_TITLE = "#sub_maintext span"
  TOPIC_DATE = ".sub_wrapper div:nth-child(3)"
  TOPIC_TIME = ".sub_wrapper tr:nth-child(1) td:nth-child(1)"
  TOPIC_DATE_NO_IMG = "#sub_maintext div+ div"
  TOPIC_TEXT_BLOB = ".sub_wrapper p"
  TOPIC_SHORT_CREDIT = ".sub_wrapper tr:nth-child(1) td:nth-child(2)" #minus the title
  TOPIC_IMG = ".media img"

  # had to take :venue out because Rake uses this class to generate tasks...
  # at which point it hasn't yet loaded the environment :(
  # @venue = Venue.find_or_create_by(name: 'Pacific Film Archive Theater')

  attr_reader :doc, :url

  def initialize(url = PfaScraper::HOME_URL)
    @url = url
    @doc = Scrape::NokoDoc.new(url).open
  end

  def make_calendars
    if calendars && !calendars.empty?
      calendars
    else
      @calendars = []
      calendar_urls = doc.find_urls(PfaScraper::HOME_CALENDAR_LINK_SELECTOR).uniq
      calendar_urls.delete_if {|u| u !~ %r'/filmseries/'}
      calendar_urls.each do |url| 
        @calendars.push PfaCalendar.new(url)
        puts url
      end
      # calendars # annoying, not worth it for now
    end
  end

  def make_topics
    if topics && !topics.empty?
      topics
    else
      @topics = []
      @calendars.each do |c| 
        t = c.make_topics_from_calendars
        @topics.concat t
        # e.each(&:title) #Something to look at while it's running!
        # topics
      end
    end
  end
end


# load 'lib/local_resource.rb'
# load 'lib/compare.rb'
# load 'lib/scrape/logger.rb'
# load 'lib/scrape/noko_doc.rb'
# load 'lib/scrape/saving.rb'

# load 'lib/scrape/base/site_scraper.rb'
# load 'lib/scrape/pfa/pfa_scraper.rb'

# load 'lib/scrape/base/calendar_scraper.rb'
# load 'lib/scrape/base/calendar_persister.rb'

# load 'lib/scrape/base/image_scraper.rb'

# load 'lib/scrape/base/topic_scraper.rb'
# load 'lib/scrape/base/topic_persister.rb'

# load 'lib/scrape/pfa/pfa_calendar.rb'
# load 'lib/scrape/pfa/pfa_topic.rb'

# load 'lib/scrape/ybca/ybca_scraper.rb'
# load 'lib/scrape/ybca/ybca_calendar.rb'
# load 'lib/scrape/ybca/ybca_topic.rb'
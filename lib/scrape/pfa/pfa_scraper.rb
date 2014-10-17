require 'scrape/base/site_scraper'
require 'scrape/noko_doc'

class PfaScraper < SiteScraper
  HOME_URL = "http://www.bampfa.berkeley.edu/filmseries/"
  HOME_CALENDAR_LINK_SELECTOR = ".textblack a"

  attr_reader :doc, :url

  def initialize(url = PfaScraper::HOME_URL)
    super
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
        t = c.make_topics_from_calendar
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
require 'open-uri'
require 'uri'

namespace :scrape do
  desc "scrape http://www.atasite.org for events"
  task ata: :environment do
    
    CALENDAR_URL = "http://www.atasite.org/calendar/"
    EVENT_LINK = ".calendarlink"
    
    # Event page
    TITLE = ".entry-title"
    DATE_TIME_ADMISSION = "#event_date"
    DESCRIPTION = ".entry-content"
  end
end
require 'open-uri'
require 'uri'

namespace :scrape do
  desc "scrape http://www.atasite.org for events"
  task ata: :environment do
    
    CALENDAR_URL = "http://www.atasite.org/calendar/"
    EVENT_LINK = ".calendarlink"
    
  end
end
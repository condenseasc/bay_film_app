require 'scrape/base/venue_scraper'
require 'scrape/pfa/pfa_scraper'

def scrape_task(scraper_class)
  class_name = scraper_class.to_s
  venue_name = /(.*)Scraper/.match(class_name)[1].downcase

  task venue_name => :environment do
    require "scrape/#{venue_name}/#{venue_name}_event"
    require "scrape/#{venue_name}/#{venue_name}_series"

    scraper = scraper_class.new
    scraper.open_pages
    scraper.scrape
    scraper.save_records
  end
end

VenueScraper.child_scrapers.each do |venue_scraper_class|
  namespace :scrape do
    scrape_task(venue_scraper_class)
  end
end


require 'scrape/base/site_scraper'
require 'scrape/pfa/pfa_scraper'
require 'scrape/ybca/ybca_scraper'

def scrape_task(scraper_class)
  class_name = scraper_class.to_s
  venue_name = /(.*)Scraper/.match(class_name)[1].downcase

  task venue_name => :environment do
    require "scrape/#{venue_name}/#{venue_name}_topic"
    require "scrape/#{venue_name}/#{venue_name}_calendar"

    scraper = scraper_class.new
    scraper.open_pages
    scraper.scrape
    scraper.save
  end
end

SiteScraper.scrapers.each do |calendar_scraper_class|
  namespace :scrape do
    scrape_task(calendar_scraper_class)
  end
end
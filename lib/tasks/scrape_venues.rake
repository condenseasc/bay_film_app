require 'scrapers/base_classes/venue_scraper'
require 'scrapers/scrape_logger'
require 'scrapers/scrape'
require 'scrapers/base_classes/scraped_series'
require 'scrapers/base_classes/scraped_event'
require 'scrapers/pfa/pfa_scraper'
# require 'scrapers/pfa/pfa_series'
# require 'scrapers/pfa/pfa_event'
require 'scrapers/scraped_stills'
require 'local_resource'
require 'compare'

def scrape_task(scraper_class)

  class_name = scraper_class.to_s
  class_sym = class_name.to_sym
  venue_name = /(.*)Scraper/.match(class_name)[1].downcase

    task class_sym => :environment do

  Rake.application.rake_require "#{Rails.root}/lib/scrapers/#{class_name.underscore}"
  Rake.application.rake_require "#{Rails.root}/lib/scrapers/#{venue_name}_event"
  Rake.application.rake_require "#{Rails.root}/lib/scrapers/#{venue_name}_series"

    scraper = scraper_class.new
    scraper.scrape
    scraper.create_records
  end
end

VenueScraper.child_scrapers.each do |venue_scraper_class|
  namespace :scrape do
    scrape_task(venue_scraper_class)
  end
end

namespace :scrape do
  desc 'blah fucking blah'
  task :gah do
    puts 'blooo fucking blueeee'
  end
end

namespace :scrape do
  desc 'scrape pfa'
  task pfa: :environment do
    require 'scrapers/pfa/pfa_scraper'
    require 'scrapers/pfa/pfa_series'
    require 'scrapers/pfa/pfa_event'

    scraper = PfaScraper.new
    scraper.open_pages
    scraper.scrape
    scraper.create_records
  end
end
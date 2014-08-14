namespace :scrape do
  VenueScraper.child_scrapers.each do |class_name|
    # change class name to downcase venue name, no 'scraper'
    task class_name => :environment do
      scraper = class_name.new
      scraper.scrape
      scraper.save
    end
  end
end
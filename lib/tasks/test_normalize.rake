
namespace :test do
  task normalize: :environment do


    require 'local_resource'
    require 'compare'
    require 'scrape/logging'
    require 'scrape/noko_doc'

    require 'scrape/base/venue_scraper'
    require 'scrape/ybca/ybca_scraper'

    require 'scrape/base/scraped_series'
    require 'scrape/base/scraped_still'
    require 'scrape/base/scraped_event'
    require 'scrape/ybca/ybca_series'
    require 'scrape/ybca/ybca_event'

    y = YbcaScraper.new
    y.make_series
    y.make_events

    File.open('log/rake_test.log') do |f|
      f.write 'it worked!'
      f.write "number of series: #{y.series.length}"
      f.write "number of events: #{y.events.length}"
      f.close
    end
  end
end
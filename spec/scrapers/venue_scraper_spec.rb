require 'spec_helper'
require_relative '../../lib/scrape/base/venue_scraper'

describe VenueScraper do
  let(:venue_scraper) { VenueScraper.new }
  let(:test_scraper)  { TestScraperClass.new }

  before(:context) do
    class TestScraperClass < VenueScraper
      def initialize
        # @logger = ActiveSupport::TaggedLogging.new(Logger.new('log/scrape_test.log')).extend(Scrape::Logging)
        @log_tags = ['venue_scraper_spec', :timestamp, :test]
        @series = []
        @events = []
      end
    end
  end


  describe 'class method' do
    describe 'attr_reader #child_scrapers' do
      it 'returns an array' do
        expect(VenueScraper.child_scrapers.class).to eq(Array)
      end

      it 'records inheriting classes after they are initialized' do
        expect(VenueScraper.child_scrapers).to include(TestScraperClass)
      end
    end
  end

end
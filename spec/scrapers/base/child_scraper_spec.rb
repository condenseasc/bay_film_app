require 'spec_helper'
require 'scrape/base/site_scraper'

class ChildScraper < SiteScraper
end

#   # attr_reader :series, :events
#   def initialize
#     # @logger = ActiveSupport::TaggedLogging.new(Logger.new('log/scrape_test.log')).extend(Scrape::Logging)
#     @log_tags = ['child_scraper_spec', :timestamp, :test]
#     @series = []
#     @events = []
#   end
# end
 

describe ChildScraper do

  # before(:example) { @event.log_tags = ['pfa_event_spec', :timestamp, :test] if @event}

  # def scraper

  # end

  let(:scraper) { ChildScraper.new }
  # let(:scraper) { instance_double 'ChildScraper' }

  describe 'instance methods' do
    it 'include scrape_#{attribute names}' do
    end

    it 'do not include attr_reader :scrapers' do
      expect(defined? scraper.scrapers).to be_falsey 
    end

    # so it's only testing that it has #series and #event available for its dummy methods
    # it doesn't have ScrapedSeries or ScrapedEvent objs to test
    # describe '#scrape' do
    #   it 'returns an instance of the child scraper' do
    #     expect(scraper.scrape).to be(scraper)
    #   end
    # end
  end

  describe 'class instance methods' do
    context 'accessing inherited class instance variable' do
      describe '#scrapers' do
        it 'returns nil' do
          expect(ChildScraper.scrapers).to be_nil
        end
      end
    end
  end
end


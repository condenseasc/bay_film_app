require 'spec_helper'
require_relative '../../../lib/scrapers/base_classes/scraped_series'
require_relative '../../../lib/scrapers/base_classes/scraped_event'
require_relative '../../../lib/scrapers/base_classes/scraped_still'
require_relative '../../../lib/scrapers/base_classes/venue_scraper'
require_relative '../../../lib/scrapers/pfa/pfa_scraper'
require_relative '../../../lib/scrapers/pfa/pfa_series'
# require_relative '../../../lib/scrapers/pfa/pfa_event' stub! otherwise we waste tons of time building events


RSpec.shared_examples 'Pfa Series' do
  before(:context) { @series.scrape }

  describe 'Series' do
    it 'has values for title and description' do
      expect(@series.title && @series.description).to be_truthy
    end
    
    it 'has Pacific Film Archive Theater as its venue' do
      expect(@series.venue.name).to eq('Pacific Film Archive Theater')
    end
  end
end 

RSpec.describe 'PfaSeries Offline specs' do
  before(:all) do
    class LocalPfaSeries < PfaSeries
      def initialize(path, url)
        @url = url
        @doc = make_doc_from_file(path, url)
        @logger = VenueScraper.logger
        @venue = PfaSeries.venue
      end
    end
  end

  before(:all) do
    @series = LocalPfaSeries.new('spec/scrapers/pfa/example_pfa_series.html', 'http://www.bampfa.berkeley.edu/filmseries/ray')
  end

  it_behaves_like 'Pfa Series'

  it 'has the right title' do
    @series.scrape
    expect(@series.title).to eq('The Brilliance of Satyajit Ray')
  end

  describe '#make_events_from_series' do
    let(:pfa_event) do
      fake_pfa_event_class = Class.new
      allow(fake_pfa_event_class).to receive(:new)
      stub_const("PfaEvent", fake_pfa_event_class)
    end

    it 'calls PfaEvent.new(url, self) 37 times' do
      expect(pfa_event).to receive(:new).with(/\/film\//, @series).exactly(37).times
      @series.make_events_from_series
    end

    it 'returns all those PfaEvents' do
      pfa_event
      expect(@series.make_events_from_series.length).to be(37)
    end
  end
end
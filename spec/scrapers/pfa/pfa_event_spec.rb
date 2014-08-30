require 'spec_helper'
require_relative '../../../lib/scrapers/base_classes/scraped_series'
require_relative '../../../lib/scrapers/base_classes/scraped_event'
require_relative '../../../lib/scrapers/base_classes/scraped_event'
require_relative '../../../lib/scrapers/base_classes/venue_scraper'
require_relative '../../../lib/scrapers/pfa/pfa_scraper'
require_relative '../../../lib/scrapers/pfa/pfa_series'
require_relative '../../../lib/scrapers/pfa/pfa_event'
require_relative '../../../lib/local_resource'

RSpec.shared_examples 'Pfa Event' do
  describe 'attributes' do
    context 'after calling #scrape' do
      it ('has non nil title')        { expect( @e.title ).to be_truthy }
      it ('has non nil time')         { expect( @e.time ).to be_truthy }
      it ('has non nil description')  { expect( @e.description ).to be_truthy }
      it ('has non nil show_credits') { expect( @e.show_credits ).to be_truthy }
      it ('has non nil show_notes')   { expect( @e.show_notes ).to be_truthy }
      it ('has non nil show_notes')   { expect( @e.show_notes ).to be_truthy }
    end
  end

  describe '#save' do 
    context 'with a unique record' do
      it 'creates a new record' do
        @e.save
        # PfaEvent.create_record(@e)
        expect(Event.count).to be(1)
      end
    end
  end
end 

RSpec.shared_context 'Local PfaEvent' do
  before(:all) do
    class LocalPfaSeries < PfaSeries
      def initialize
        @venue = PfaSeries.venue
        @series = Series.create(title: 'Fall 2014', venue: PfaSeries.venue)
      end
    end

    # Series.create(title: 'Fall 2014', venue: PfaSeries.venue)

    class LocalPfaEvent < PfaEvent
      def initialize(path, url, series)
        @url = url
        @doc = make_doc_from_file(path, url)
        @series = [LocalPfaSeries.new]
        @venue = PfaEvent.venue
        @logger = VenueScraper.logger
      end
    end
  end 
end

RSpec.describe 'PfaEvent Offline With Image' do
  include_context 'Local PfaEvent'

  before(:all) do
   @e = LocalPfaEvent.new('spec/scrapers/pfa/example_pfa_event.html', 
    'http://www.bampfa.berkeley.edu/film/FN20724',
    LocalPfaSeries.new)
    # Series.create(title: 'Fall 2014', venue: PfaSeries.venue))
    # LocalPfaSeries.new('spec/scrapers/pfa/example_pfa_series.html', 'http://www.bampfa.berkeley.edu/filmseries/ray') )
  end
  before(:context) { @e.scrape }

  it_behaves_like 'Pfa Event'
  it 'has the right title' do
    expect(@e.title).to eq('The Chess Players')
  end

  describe 'stills' do
    it 'has non nil stills' do
      expect( @e.stills.empty? ).to be(false)
    end

    it 'has ScrapedStills in its stills' do
      expect( @e.stills.first.class ).to eq(ScrapedStill)
    end 
  end
end

RSpec.describe 'PfaEvent Offline No Image' do
  include_context 'Local PfaEvent'

  before(:all) do
   @e = LocalPfaEvent.new('spec/scrapers/pfa/example_pfa_event_no_img.html', 
    'http://www.bampfa.berkeley.edu/film/FN20724',
    LocalPfaSeries.new)
    # ('spec/scrapers/pfa/example_pfa_series.html', 'http://www.bampfa.berkeley.edu/filmseries/ray')) 
  end
  before(:context) { @e.scrape }

  it_behaves_like 'Pfa Event'

  describe 'stills' do
    it 'has no stills' do
      expect( @e.stills.empty? ).to be(true)
    end
  end

  describe '#save' do
    before(:example) { @e.scrape; @e.save }

    it 'saves an event' do
      expect(Event.count).to eq(1)
    end
  end
end
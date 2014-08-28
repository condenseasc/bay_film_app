require 'spec_helper'
require_relative '../../../lib/scrapers/base_classes/scraped_series'
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
end 

RSpec.shared_context 'Local PfaEvent' do
  before(:all) do
    class LocalPfaEvent < PfaEvent
      def initialize(path, url, series)
        @url = url
        @doc = make_doc_from_file(path, url)
        @series = series
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
    OpenStruct.new(url: nil))
  end
  before(:context) { @e.scrape }

  it_behaves_like 'Pfa Event'

  describe 'stills' do
    it 'has non nil stills' do
      expect( @e.stills.empty? ).to be(false)
    end

    it 'has Stills in its stills' do
      expect( @e.stills.first.class ).to eq(Still)
    end
  end

end

RSpec.describe 'PfaEvent Offline No Image' do
  include_context 'Local PfaEvent'

  before(:all) do
   @e = LocalPfaEvent.new('spec/scrapers/pfa/example_pfa_event_no_img.html', 
    'http://www.bampfa.berkeley.edu/film/FN20724',
    OpenStruct.new(url: nil))
  end
  before(:context) { @e.scrape }

  it_behaves_like 'Pfa Event'

  describe 'stills' do
    it 'has no stills' do
      expect( @e.stills.empty? ).to be(true)
    end
  end

  describe '#create_record' do
    before(:example) { @e.create_record }

    it 'saves an event' do
      expect(Event.count).to eq(1)
    end
  end
end
require 'spec_helper'
require 'scrape/base/scraped_series'
require 'scrape/base/scraped_event'
require 'scrape/base/scraped_event'
# require 'scrape/base/venue_scraper'
# require 'scrape/pfa/pfa_scraper'
require 'scrape/pfa/pfa_series'
require 'scrape/pfa/pfa_event'
require 'local_resource'
# require 'scrape/noko_doc'

RSpec.shared_examples 'Pfa Event' do
  after(:example) { Event.destroy_all; Series.destroy_all}
  describe 'attributes' do
    context 'after calling #scrape' do
      it ('has non nil title')        { expect( @e.title ).to be_truthy }
      it ('has non nil time')         { expect( @e.time ).to be_truthy }
      it ('has non nil description')  { expect( @e.description ).to be_truthy }
      it ('has non nil short_credit') { expect( @e.short_credit ).to be_truthy }
      it ('has non nil announcement') { expect( @e.announcement ).to be_truthy }
      it ('has non nil announcement') { expect( @e.announcement ).to be_truthy }
    end
  end

  describe '#save_record_with_associations' do 
    let(:pfa_event) do 
      PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
        path:'spec/scrapers/pfa/example_pfa_event.html', 
        series:[ PfaSeries.new('http://www.bampfa.berkeley.edu/filmseries/ray', path:'spec/scrapers/pfa/example_pfa_series.html') ] )
    end

    # before(:example) { @e.scrape; @e.save_record_with_associations }
    context 'with a unique record' do
      it 'has PfaSeries in an array' do
        expect(pfa_event.series.first.class).to be(PfaSeries)
      end

      it 'works here' do
        pfa_event.series = pfa_event.series.map { |s| s.save_record }
        expect(pfa_event.series.class).to be(Array)
      end


      it 'works here after scraping' do
        pfa_event.scrape
        pfa_event.series = pfa_event.series.map { |s| s.save_record }
        expect(pfa_event.series.first.persisted?).to be(true)
      end

      it 'creates a new record' do
        pfa_event.scrape
        pfa_event.save_record_with_associations
        expect(Event.count).to be(1)
      end
    end
  end
end 

RSpec.shared_context 'Local PfaEvent' do
  before(:example) { @e.log_tags = ['pfa_event_spec', :timestamp, :test] }
  # before(:all) do
  #   # class MND
  #   #   include Scrape::NokoDocs
  #   #   # local_doc = make_doc_from_file('spec/scrapers/pfa/example_pfa_event_no_img.html', 
  #   #   #     'http://www.bampfa.berkeley.edu/film/FN20724')
  #   # end
  #   # local_doc = MND.new.make_doc_from_file('spec/scrapers/pfa/example_pfa_event_no_img.html', 
  #   #       'http://www.bampfa.berkeley.edu/film/FN20724')

  #   # local_doc = Scrape::NokoDocs.make_doc_from_file('spec/scrapers/pfa/example_pfa_event_no_img.html', 
  #   #       'http://www.bampfa.berkeley.edu/film/FN20724')

  #   class LocalPfaSeries < PfaSeries
  #     def initialize('http://www.bampfa.berkeley.edu/film/FN20724', doc='placeholder')
  #       super
  #       @record = Series.find_or_create_by(title: 'Fall 2014', venue: PfaSeries.venue)
  #       # @record = FactoryGirl.create(:series)
  #       # @logger = ActiveSupport::TaggedLogging.new(Logger.new('log/scrape_test.log')).extend(Scrape::Logging)
  #       @log_tags = ['pfa_event_spec', :timestamp, :test]
  #     end
  #   end

  #   class LocalPfaEvent < PfaEvent
  #     def initialize('http://www.bampfa.berkeley.edu/film/FN20724', path: 'spec/scrapers/pfa/example_pfa_event_no_img.html', series:[LocalPfaSeries.new])
  #       super
  #       # @url = url
  #       # @doc = make_doc_from_file(path, url)
  #       # @series = [LocalPfaSeries.new]
  #       # @venue = PfaEvent.venue
  #       # @logger = ActiveSupport::TaggedLogging.new(Logger.new('log/scrape_test.log')).extend(Scrape::Logging)
  #       @log_tags = ['pfa_event_spec', :timestamp, :test]
  #     end
  #   end
  # end 
end

RSpec.describe 'PfaEvent Offline With Image' do
  include_context 'Local PfaEvent'
  after(:example) { Event.destroy_all; Series.destroy_all}

  before(:all) do
   @e = PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
      path:'spec/scrapers/pfa/example_pfa_event.html', 
      series:[ PfaSeries.new('http://www.bampfa.berkeley.edu/filmseries/ray', path:'spec/scrapers/pfa/example_pfa_series.html') ] )
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

  # describe '#save_record_with_associations' do
  #   before(:example) { @e.scrape; @e.save_record_with_associations }

  #   it 'saves an event' do
  #     expect(Event.count).to eq(1)
  #   end
  # end
end

RSpec.describe 'PfaEvent Offline No Image' do
  include_context 'Local PfaEvent'
  after(:example) { Event.destroy_all; Series.destroy_all}
  before(:all) do
   @e = PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20720', 
      path:'spec/scrapers/pfa/example_pfa_event_no_img.html', 
      series:[ PfaSeries.new('http://www.bampfa.berkeley.edu/filmseries/ray', path:'spec/scrapers/pfa/example_pfa_series.html') ] )
   # @e.series.each(&:scrape)
  end
  before(:context) { @e.scrape }

  it_behaves_like 'Pfa Event'

  it 'has the right title' do
    expect(@e.title).to eq('Sikkim')
  end

  describe 'stills' do
    it 'has no stills' do
      expect( @e.stills.empty? ).to be(true)
    end
  end

  # describe '#save_record_with_associations' do

  #   it 'saves an event' do
  #     expect(Event.count).to eq(1)
  #   end
  # end
end

require 'scrape/base/scraped_series'
require 'scrape/pfa/pfa_series'
require 'scrape/pfa/pfa_event'

RSpec.describe 'ScrapedEvent implemented as PfaEvent' do
  before(:example) { @event.log_tags = ['scraped_event_implementation_spec', :timestamp, :test] if @event }

  describe 'with Series' do
    def event
      PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
        path:'spec/scrapers/pfa/example_pfa_event.html', 
        series:[ PfaSeries.new('http://www.bampfa.berkeley.edu/filmseries/ray', 
          path:'spec/scrapers/pfa/example_pfa_series.html') ] )
    end

    before(:context) { Event.destroy_all; Series.destroy_all}


    describe '#save_record_with_associations' do
      before(:context) { @event = event }
      context 'without scraping' do
        it 'still saves' do
          @event.save_record_with_associations
          expect( @event.persisted? ).to be(true)
          expect( @event.series.all?(&:persisted?) ).to be(true)
          expect( Event.count ).to be(1)
        end
      end

      context 'after scraping, with a unique record' do
        before(:context) { @event = event.scrape; @event.series.each(&:scrape) }
        
        it('has series in an array') { expect(@event.series.class).to be(Array) }
        it('holds ScrapedSeries') { expect(@event.series.first.class.superclass).to be(ScrapedSeries) }

        describe 'using #save_record' do
          # before(:example) { @event.series.each { |s| s.save_record } }
          # it_behaves_like 'Scraped Event with Series with functioning persistence'
          before(:context) { @event.save_record }

          it('does not persist series') { expect(@event.series.first.persisted?).to be(false) }
          it('persists itself') { expect(@event.persisted?).to be(true) }
        end

        describe 'using #save_record_with_associations' do
          before(:context) { @event = event.scrape; @event.series.each(&:scrape) }
          before(:context) { @event.save_record_with_associations}

          it 'has matching series on object and in record' do
            object_ids = @event.series.map        { |s| s.id }
            record_ids = @event.record.series.map { |s| s.id }

            expect(record_ids).to eq(object_ids)
          end

          it 'has only persisted records' do
            series_object_persistence = @event.series.all?( &:persisted? )
            series_record_persistence = @event.record.series.all?( &:persisted? )
            event_persistence = @event.persisted?

            expect(series_record_persistence && series_object_persistence && event_persistence).to be(true)
          end

          it('creates a new Series record') { expect(Series.count).to be(1) }
          it('creates a new Event record')  { expect(Event.count).to  be(1) }
        end
      end
    end
  end

  describe 'with a Still and a Series' do
    def event
      PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
        path:'spec/scrapers/pfa/example_pfa_event.html',
        series:[ PfaSeries.new( 'http://www.bampfa.berkeley.edu/filmseries/ray', 
          path:'spec/scrapers/pfa/example_pfa_series.html') ] )
    end

    before(:context) { Event.destroy_all; Series.destroy_all; Still.destroy_all }
    before(:context) { @event = event.scrape }

    it('has non nil stills')     { expect( @event.stills.empty? ).to be(false) }
    it('holds ScrapedStills')    { expect( @event.stills.first.class ).to eq(ScrapedStill) }
    it('has correct # of stills'){ expect( @event.stills.length).to be(1) }

    context 'saving' do
      before(:context) { @event.save_record_with_associations }

      it('creates a new Event record') { expect( Event.count ).to be(1) }
      it('creates a new Still record') { expect( Still.count ).to be(1) }
      it('creates a new Series record'){ expect( Series.count ).to be(1) }
      it('persists Event')             { expect( @event.persisted? ).to be(true) }
      it('persists Still')             { expect( @event.stills.all?(&:persisted?) ).to be(true) }
      it('persists Series')            { expect( @event.series.all?(&:persisted?) ).to be(true) }
      it('saves a Still image')        { expect( @event.stills.first.image.size).to be > 100 }
    end
  end

  describe 'without Stills or Series' do
    def event
      PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20720', 
        path:'spec/scrapers/pfa/example_pfa_event_no_img.html')
    end

    before(:context) { Event.destroy_all; Still.destroy_all; Series.destroy_all }

    context 'after scraping' do
      before(:context) { @event = event.scrape }

      it('has nil series') { expect( @event.series ).to be(nil) }
      it('has nil stills') { expect( @event.stills ).to be(nil) }

      describe 'calling #save_record_with_associations' do
        before(:context) { @event.save_record_with_associations }


        it('creates a new Event record')  { expect(Event.count).to be(1) }
        it('creates no Stills or Series') { expect(Series.count + Still.count).to eq(0) }
        it('is persisted')                { expect(@event.persisted?).to be(true) }
      end
    end
  end

  describe 'very basic, no associations' do
    def event
      PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
        path:'spec/scrapers/pfa/example_pfa_event.html')
    end

    before(:context) { Event.destroy_all }

    context 'after calling #scrape' do
      before(:context) { @event = event.scrape }

      it('has non nil title') { expect( @event.title).to be_truthy }
      it('has non nil time')  { expect( @event.time ).to be_truthy }
      it('has non nil venue') { expect( @event.venue).to be_truthy }
    end

    describe 'saving' do    
      context 'with #save_record_with_associations' do
        before(:context) do
          @event = event.scrape
          @event.save_record_with_associations
        end

        it('creates a new Event record') { expect(Event.count).to be(1) }
        it('is persisted')               { expect(@event.persisted?).to be(true) }
      end

      context 'with #save_record' do
        before(:context) do
          @event = event.scrape
          @event.save_record
        end
        it('creates a new Event record') { expect(Event.count).to be(1) }
        it('is persisted')               { expect(@event.persisted?).to be(true) }
      end
    end
  end
end

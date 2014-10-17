
# require 'scrape/base/calendar_scraper'
require 'scrape/pfa/pfa_calendar'
require 'scrape/pfa/pfa_topic'

RSpec.describe 'ScrapedTopic implemented as PfaTopic' do
  def topic_scraper
    topic
  end

  describe 'with Calendar' do
    def topic
      PfaTopic.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
        path:'spec/scrapers/pfa/example_pfa_topic.html', 
        calendar_scraper: PfaCalendar.new('http://www.bampfa.berkeley.edu/filmseries/ray', 
          path:'spec/scrapers/pfa/example_pfa_calendar.html',
          log_tags: ['scraped_topic_implementation_spec', :test]
          ),
        log_tags: ['scraped_topic_implementation_spec', :test]
        )
    end

    describe '#save' do
      before(:context) { @topic = topic_scraper }
      context 'without scraping' do
        it 'still saves' do
          Topic.destroy_all
          Calendar.destroy_all
          @topic.save
          expect( @topic.persisted? ).to be(true)
          expect( @topic.calendar_scraper.persisted? ).to be(true)
          expect( Topic.count ).to be(1)
        end
      end

      context 'after scraping, with a unique record' do
        before(:context) do
          Topic.destroy_all
          @topic = topic_scraper.scrape
          @topic.calendar_scraper.scrape
        end
        
        it 'holds CalendarScraper' do
          expect(@topic.calendar_scraper.class.superclass).to be(CalendarScraper)
        end

        describe 'using #save' do
          # it_behaves_like 'Scraped Topic with Calendar with functioning persistence'
          before(:context) { @topic.save }

          it 'persists itself' do
            expect(@topic.persisted?).to be(true)
          end

          it 'persists calendar_scraper' do
            expect(@topic.calendar_scraper.persisted?).to be true
          end

          it 'has matching calendar on object and in record' do
            object_id = @topic.calendar_scraper.id
            record_id = @topic.record.calendar.id

            expect(record_id).to eq(object_id)
          end

          it 'has only persisted records' do
            calendar_object_persistence = @topic.calendar_scraper.persisted?
            calendar_record_persistence = @topic.record.calendar.persisted?
            topic_persistence           = @topic.persisted?
            image_persistence           = @topic.record.images.all? {|img| img.persisted? }

            expect(calendar_record_persistence && calendar_object_persistence && 
                             topic_persistence && image_persistence).to be(true)
          end

          it('creates a new Calendar record') { expect(Calendar.count).to be 1 }
          it('creates a new Topic record')    { expect(Topic.count).to be 1 }
          it('creates a new Image record')    { expect(Image.count).to be 2 }
        end
      end
    end
  end

  describe 'with an Image and a Calendar' do
    def topic
      PfaTopic.new('http://www.bampfa.berkeley.edu/film/FN20724', 
        path:'spec/scrapers/pfa/example_pfa_topic.html',
        calendar_scraper: PfaCalendar.new( 'http://www.bampfa.berkeley.edu/filmseries/ray', 
          path:'spec/scrapers/pfa/example_pfa_calendar.html',
          log_tags: ['scraped_topic_implementation_spec', :test]
          ),
        log_tags: ['scraped_topic_implementation_spec', :test]
        )
    end


    before(:context) { Topic.destroy_all; Calendar.destroy_all; Image.destroy_all }
    before(:context) { @topic = topic_scraper.scrape }

    it('has image_scrapers')      { expect( @topic.image_scrapers.empty? ).to be(false) }
    it('holds ImageScrapers')     { expect( @topic.image_scrapers.first.class ).to eq(ImageScraper) }
    it('has correct # of images') { expect( @topic.image_scrapers.length).to be(1) }

    context 'saving' do
      before(:context) { @topic.save }

      it('creates a new Topic record') { expect( Topic.count ).to be(1) }
      it('creates a new Image record') { expect( Image.count ).to be(2) }
      it('creates an image for topic') {expect(@topic.record.images.size).to be 1 }
      it('creates an image for cal')   { expect(@topic.record.calendar.images.size).to be 1 }
      it('creates new Calendar record'){ expect( Calendar.count ).to be(1) }
      it('persists Topic')             { expect( @topic.persisted? ).to be(true) }
      it('persists Image')             { expect( @topic.image_scrapers.all?(&:persisted?) ).to be(true) }
      it('persists Calendar')          { expect( @topic.calendar_scraper.persisted? ).to be(true) }
      it('saves a Image image')        { expect( @topic.image_scrapers.first.record.asset.size).to be > 100 }
    end
  end

  describe 'without Images or Calendar' do
    def topic
      PfaTopic.new( 'http://www.bampfa.berkeley.edu/film/FN20720', 
        path:'spec/scrapers/pfa/example_pfa_topic_no_img.html',
        log_tags: ['scraped_topic_implementation_spec', :test])
    end

    before(:context) { Topic.destroy_all; Image.destroy_all; Calendar.destroy_all }

    context 'after scraping' do
      before(:context) { @topic = topic_scraper.scrape }

      it('has nil calendar') { expect( @topic.calendar_scraper ).to be(nil) }
      it('has empty images') { expect( @topic.image_scrapers.empty?    ).to be(true) }

      describe '#save' do
        before(:context) { @topic.save }

        it('creates a new Topic record')  { expect(Topic.count).to be(1) }
        it('creates no Images or Calendar') { expect(Calendar.count + Image.count).to eq(0) }
        it('is persisted')                { expect(@topic.persisted?).to be(true) }
      end
    end
  end

  describe 'very basic, no associations' do
    def topic
      PfaTopic.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
        path:'spec/scrapers/pfa/example_pfa_topic.html',
        log_tags: ['scraped_topic_implementation_spec', :test])
    end

    context 'after calling #scrape' do
      before(:context) { @topic = topic_scraper.scrape }

      it('has non nil title')  { expect( @topic.title).to be_truthy }
      it('has non nil events') { expect( @topic.events).to be_truthy }
      it('has non nil venue')  { expect( @topic.events.first.venue).to be_truthy }
    end

    describe '#save' do    
      before(:context) do
        Topic.destroy_all
        @topic = topic_scraper.scrape
        @topic.save
      end

      it('creates a new Topic record') { expect(Topic.count).to be(1) }
      it('is persisted')               { expect(@topic.persisted?).to be(true) }
    end
  end
end

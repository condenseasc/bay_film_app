require 'scrape/ybca/ybca_scraper'
require 'scrape/ybca/ybca_calendar'
require 'scrape/ybca/ybca_topic'
require 'scrapers/scraper_shared_examples'

RSpec.describe YbcaScraper do

  # it_behaves_like 'a scraper'

  before(:context) { @scraper = YbcaScraper.new }

  context 'after making calendar and topics' do
    before(:context) { @scraper.make_calendars; @scraper.make_topics }

    it 'holds YbcaCalendar' do
      expect(@scraper.calendars.all? { |s| s.class == YbcaCalendar }).to be(true)
    end

    it 'holds YbcaTopics' do
      expect(@scraper.topics.all? { |e| e.class == YbcaTopic }).to be(true)
    end

    context 'with topics inside and outside calendars' do
      before(:context) do
        @t_alone          = @scraper.topics.select { |e| e.calendar_scraper == nil }
        @t_alone_set      = @t_alone.map( &:url ).to_set

        @t_in_calendar      = @scraper.topics.select { |e| e.calendar_scraper != nil }
        @t_in_calendar_set  = @t_in_calendar.map( &:url ).to_set

        @t_in_ybca_calendar = @scraper.topics.select do |e|
          e.calendar_scraper != nil && e.calendar_scraper.class == YbcaCalendar
        end
      end

      it 'has more than zero topics without calendar' do
        puts "Topics in YBCA without Calendar: #{@t_alone.size}"
        expect( @t_alone.size ).to be > 0
      end

      it 'keeps only unique topics, by url' do
        puts "Unique Topics in YBCA without Calendar: #{@t_alone_set.size}"
        expect( @t_alone.size ).to eq( @t_alone_set.size )
      end

      it 'has proper calendar on topics in calendar' do
        expect( @t_in_calendar.size ).to eq( @t_in_ybca_calendar.size )
      end


      it 'only has these two groups, kept separate' do
        unique_topic_total = @t_alone_set.size + @t_in_calendar_set.size
        expect( unique_topic_total ).to eq(@scraper.topics.size)
      end

      it 'has no overlap between these topics' do
        expect( @t_alone_set.disjoint? @t_in_calendar_set ).to be(true)
      end

    end
  end
end



require 'spec_helper'
require 'scrape/base/calendar_scraper'
require 'scrape/base/topic_scraper'
require 'scrape/base/image_scraper'
require 'scrape/pfa/pfa_calendar'


RSpec.shared_examples 'Pfa Calendar' do
  before(:context) { @calendar = calendar_with_test_logs.scrape }

  context 'after scraping,' do
    describe 'Calendar' do
      it 'has values for title and body' do
        expect(@calendar.title && @calendar.body).to be_truthy
      end
      
      # re-impement with organizer/owner. venues belong on events.
      # it 'has Pacific Film Archive Theater as its venue' do
      #   expect(@calendar.venue.name).to eq('Pacific Film Archive Theater')
      # end
    end
  end
end 

RSpec.describe 'PfaCalendar Offline specs' do
  def calendar_with_test_logs
    s = calendar
    s.log_tags = ['pfa_calendar_spec', :timestamp, :test]
    s
  end

  def calendar
    PfaCalendar.new('http://www.bampfa.berkeley.edu/filmseries/ray', 
      path:'spec/scrapers/pfa/example_pfa_calendar.html')
  end

  it_behaves_like 'Pfa Calendar'
  context 'after scraping' do
    before(:context) { @calendar = calendar_with_test_logs.scrape }

    it 'has the right title' do
      expect(@calendar.title).to eq('The Brilliance of Satyajit Ray')
    end

    describe '#make_topics_from_calendar' do
      let(:pfa_topic) do
        fake_pfa_topic_class = Class.new
        allow(fake_pfa_topic_class).to receive(:new)
        stub_const("PfaTopic", fake_pfa_topic_class)
      end

      it 'calls PfaTopic.new(url, self) 37 times' do
        expect(pfa_topic).to receive(:new).with(/\/film\//, calendar_scraper:@calendar).exactly(37).times
        @calendar.make_topics_from_calendar
      end

      it 'returns all those PfaTopics' do
        pfa_topic
        expect(@calendar.make_topics_from_calendar.length).to be(37)
      end
    end
  end


  context 'without scraping' do
    before(:example) { @calendar_scraper = calendar_with_test_logs }

    describe 'saving' do
      context 'using #save' do
        it 'starts out with a nil record' do
          expect(@calendar_scraper.record).to be(nil)
        end

        it 'still manages to save' do
          @calendar_scraper.save
          expect(@calendar_scraper.record.persisted?).to be(true)
        end
      end
    end
  end
end
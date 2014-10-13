require 'spec_helper'
require 'scrape/base/calendar_scraper'
require 'compare'



RSpec.describe CalendarScraper do
  let(:event)     { build(:event) }
  let(:calendar)  { build(:calendar, scraped: true) }
  let(:calendar_scraper) do
    cal = CalendarScraper.new('http://www.bampfa.berkeley.edu/filmseries/ray', 
                    path:'spec/scrapers/pfa/example_pfa_calendar.html',
                    log_tags:['scraped_calendar_spec', :test])
    cal.record = calendar
    cal
  end

  describe 'record' do
    it 'holds a Calendar' do
      expect(calendar_scraper.record.class).to be Calendar
    end

    it 'is unsaved' do
      expect(calendar_scraper.record.new_record?).to be(true)
    end
  end

  describe '#save' do
    context 'with new record' do
      it 'persists record' do
        calendar_scraper.save
        expect(calendar_scraper.record.persisted?).to be(true)
      end

      it 'returns true on success' do
        Calendar.destroy_all
        expect(calendar_scraper.save).to be true
        expect(calendar_scraper.record.persisted?).to be true
      end
    end

    context 'with identical record' do
      before(:example)        { calendar_scraper.save; identical_calendar_scraper }
      let(:identical_calendar_scraper) do
        cal = calendar_scraper
        cal.record = Calendar.new( title: calendar.title, scraped: true )
        cal
      end
      let(:record_after_save) { identical_calendar_scraper.save; identical_calendar_scraper.record }


      it 'returns a persisted record' do
        expect(record_after_save.persisted?).to be(true)
      end

      it 'returns the already-persisted, pre-existing calendar' do
        expect(record_after_save).to eq(calendar)
      end

      it 'makes no changes to existing record' do
        expect(calendar.created_at).to eq(calendar.updated_at)
      end
    end

    it 'calendar is not already saved' do
      expect(calendar.new_record?).to be(true)
    end

    context 'with updated record' do
      before(:example) { calendar_scraper.save }
      # let(:original_calendar)  { calendar }

      let(:updated_calendar) do
        cal = Calendar.new( title: calendar.title, scraped: true)
        cal.body = 'boondogle'
        cal
      end

      let(:updated_calendar_scraper) { calendar_scraper.record = updated_calendar; calendar_scraper }
      let(:record_after_save)        { updated_calendar_scraper.save; updated_calendar_scraper.record }

      it 'returns true' do
        Calendar.destroy_all
        calendar_scraper.save

        expect(updated_calendar_scraper.save).to be true
      end

      it 'starting with a fresh record, no id, but sharing a title with our original calendar' do
        expect(updated_calendar.id).to be(nil)
        expect(updated_calendar.new_record?).to be(true)
      end

      it 'returns a persisted calendar' do
        expect(record_after_save.persisted?).to be(true)
      end

      it 'returns a record with the same id as the original' do
        expect(record_after_save).to eq(calendar)
      end

      it 'indeed updates a record' do
        expect(record_after_save.created_at).not_to eq(record_after_save.updated_at)
      end

      it 'has the new field' do
        expect(record_after_save.body).to eq('boondogle')
      end

      it 'does not alter any other fields' do
        diff = Compare::Records.attribute_difference_between( calendar, record_after_save )
        expect(diff).to eq({body: 'boondogle'})
      end
    end
  end

  # describe 'instance method' do 
  #   describe 'scrape_#{attr}' do
  #     context 'scrape_#{attr} method not defined on subclass' do
  #       it 'method_missing catches and returns nil if attr is in schema' do
  #         expect(TestCalendar.new.scrape_title).to be_nil
  #       end
  #     end
  #   end
  # end

end
require 'spec_helper'
require 'scrape/base/scraped_event'
require 'scrape/base/venue_scraper'
require 'compare'


RSpec.describe ScrapedEvent do
  before(:all) do
    class MockScrapedEvent < ScrapedEvent
      attr_accessor :record
      # arbitrary placeholder event, won't be touched
      def initialize(url='http://www.bampfa.berkeley.edu/film/FN20724', path:'spec/scrapers/pfa/example_pfa_event.html')
        super
        # @logger = ActiveSupport::TaggedLogging.new(Logger.new('log/scrape_test.log')).extend(Scrape::Logging)
        @log_tags = ['scraped_event_spec', :timestamp, :test]
      end
    end
  end

  let( :event ) { FactoryGirl.build(:event) }
  let( :venue ) { FactoryGirl.build(:venue) }
  let( :scraped_event) { s = MockScrapedEvent.new; s.record = event; s }
  # subject  { event }

  describe "#save_record" do
    it "scraped event holds an event" do
      expect(scraped_event.record.new_record?).to be(true)
    end

    it 'gives scraped event a persisted record' do
      scraped_event.save_record
      expect(scraped_event.record.persisted?).to be(true)
    end

    context 'with a duplicate event' do
      before(:example) { scraped_event.save_record }
      let(:dup_event) { Event.new(event.attributes) }
      let(:dup_scraped_event) { s=MockScrapedEvent.new; s.record=dup_event; s }

      it "does not save a record with identical attributes" do
        # expect(scraped_event.record.persisted?).to be(true)
        returned_event = dup_scraped_event.save_record
        expect(scraped_event.attribute_difference_from(returned_event)).to be(nil)
        expect(returned_event.updated_at).to eq(returned_event.created_at)
      end

      it 'returns matching persisted record' do
        returned_event = dup_scraped_event.save_record
        expect(returned_event).to eq(scraped_event.record)
      end
    end

    context 'with updated event' do
      before(:example) { scraped_event.save_record }
      let(:edited_event) { e = Event.new(event.attributes); e.body = "fresh text!"; e }
      let(:edited_scraped_event) { s = scraped_event; s.record = edited_event; s }
      let(:returned_event) { edited_scraped_event.save_record }

      it 'updates existing record' do
        expect(returned_event.created_at).not_to eq(returned_event.updated_at)
      end

      it 'has the right update' do
        expect(returned_event.body).to eq('fresh text!')
      end

      it 'did not mess up the other fields' do
        diff = Compare::Records.attribute_difference_between(event, returned_event)
        expect(diff).to eq({body: 'fresh text!'})
      end 
    end

    context 'with invalid event' do
      let(:invalid_event) { e=event; e.times=nil; e }
      let(:invalid_scraped_event) { s=scraped_event; s.record=invalid_event; s}
      let(:returned_event) { invalid_scraped_event.save_record }

      it 'returns nil' do
        expect(returned_event).to be(nil)
      end
    end
  end
end
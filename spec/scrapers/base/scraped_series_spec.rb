require 'spec_helper'
require 'scrape/base/scraped_series'
require 'scrape/base/venue_scraper'
require 'compare'



RSpec.describe 'ScrapedSeries' do

  before(:all) do
    class MockScrapedSeries < ScrapedSeries
      attr_accessor :record
      # placeholder series, just to initialize.
      def initialize(url='http://www.bampfa.berkeley.edu/filmseries/ray', path:'spec/scrapers/pfa/example_pfa_series.html')
        super
        @log_tags = ['scraped_series_spec', :timestamp, :test]
      end
    end
  end

  let(:event) { FactoryGirl.build(:event) }
  let(:series) { FactoryGirl.build(:series) }
  let(:scraped_series) {s=MockScrapedSeries.new; s.record=series; s }

  describe 'record' do
    it 'holds a Series' do
      expect(scraped_series.record.new_record?).to be(true)
    end
  end

  describe '#save_record' do
    describe 'with one identical venue' do 
      before(:example) { scraped_series.record.venue = FactoryGirl.create(:venue) }

      context 'with new record' do
        before(:example) { scraped_series.save_record }
        it 'persists record' do
          expect(scraped_series.record.persisted?).to be(true)
        end
      end

      context 'with identical record' do
        before(:example) { scraped_series.save_record }
        let(:identical_scraped_series) { s=MockScrapedSeries.new; s.record=Series.new(series.attributes); s }
        let(:returned_series) { identical_scraped_series.save_record }


        it 'returns a persisted record' do
          expect(returned_series.persisted?).to be(true)
        end

        it 'returns the already-persisted, pre-existing series' do
          expect(returned_series).to eq(series)
        end

        it 'makes no changes to existing record' do
          expect(series.created_at).to eq(series.updated_at)
        end
      end

      it 'series isn not already saved' do
        expect(series.new_record?).to be(true)
      end

      context 'with updated record' do
        before(:example) { scraped_series.save_record }
        let(:original_series) { series }
        let(:edited_series) { s=Series.new(original_series.attributes); s.description='boondogle'; s.id=nil; s }
        let(:edited_scraped_series) { scraped_series.record = edited_series; scraped_series }
        let(:returned_series) { edited_scraped_series.save_record }

        # before(:example) do
        #   @original_series = series
        #   @original_scraped_series = MockScrapedSeries.new
        #   @original_scraped_series.record = @original_series

        #   @updated_series = Series.new(@original_series.attributes)
        #   @updated_series.description = 'boondogle'
        #   @updated_scraped_series = MockScrapedSeries.new
        #   @updated_scraped_series.record = @updated_series

        #   @original_scraped_series.save_record
        #   @returned_series = @updated_scraped_series.save_record
        # end

        it 'starting with a fresh record, no id, but sharing a title and venue with our original series' do
          expect(edited_series.id).to be(nil)
          expect(edited_series.new_record?).to be(true)
        end
 
        it 'returns a persisted series' do
          expect(returned_series.persisted?).to be(true)
        end

        it 'returns a record with the same id as the original' do
          expect(returned_series).to eq(original_series)
        end

        it 'indeed updates a record' do
          expect(returned_series.created_at).not_to eq(returned_series.updated_at)
        end

        it 'has the new field' do
          expect(returned_series.description).to eq('boondogle')
        end

        it 'does not alter any other fields' do
          diff = Compare::Records.attribute_difference_between(original_series, returned_series)
          expect(diff).to eq({description: 'boondogle'})
        end
      end
    end
  end

  

  # describe 'instance method' do 
  #   describe 'scrape_#{attr}' do
  #     context 'scrape_#{attr} method not defined on subclass' do
  #       it 'method_missing catches and returns nil if attr is in schema' do
  #         expect(TestSeries.new.scrape_title).to be_nil
  #       end
  #     end
  #   end
  # end

end
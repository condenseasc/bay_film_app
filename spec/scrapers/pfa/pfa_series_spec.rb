require 'spec_helper'
require 'scrape/base/scraped_series'
require 'scrape/base/scraped_event'
require 'scrape/base/scraped_still'
require 'scrape/pfa/pfa_series'


RSpec.shared_examples 'Pfa Series' do
  before(:context) { @series = series_with_test_logs.scrape }

  context 'after scraping,' do
    describe 'Series' do
      it 'has values for title and body' do
        expect(@series.title && @series.body).to be_truthy
      end
      
      it 'has Pacific Film Archive Theater as its venue' do
        expect(@series.venue.name).to eq('Pacific Film Archive Theater')
      end
    end
  end
end 

RSpec.describe 'PfaSeries Offline specs' do
  def series_with_test_logs
    s = series
    s.log_tags = ['pfa_series_spec', :timestamp, :test]
    s
  end

  def series
    PfaSeries.new('http://www.bampfa.berkeley.edu/filmseries/ray', 
      path:'spec/scrapers/pfa/example_pfa_series.html')
  end

  it_behaves_like 'Pfa Series'
  context 'after scraping' do
    before(:context) { @series = series_with_test_logs.scrape }

    it 'has the right title' do
      expect(@series.title).to eq('The Brilliance of Satyajit Ray')
    end

    describe '#make_events_from_series' do
      let(:pfa_event) do
        fake_pfa_event_class = Class.new
        allow(fake_pfa_event_class).to receive(:new)
        stub_const("PfaEvent", fake_pfa_event_class)
      end

      it 'calls PfaEvent.new(url, self) 37 times' do
        expect(pfa_event).to receive(:new).with(/\/film\//, series:[@series]).exactly(37).times
        @series.make_events_from_series
      end

      it 'returns all those PfaEvents' do
        pfa_event
        expect(@series.make_events_from_series.length).to be(37)
      end
    end
  end


  context 'without scraping' do
    before(:example) { @series = series_with_test_logs; puts @series.record }

    describe 'saving' do
      context 'using #save_with_associations' do
        it 'starts out with a nil record' do
          expect(@series.record).to be(nil)
        end

        it 'still manages to save' do
          @series.save_record_with_associations
          expect(@series.record.persisted?).to be(true)
        end
      end
    end
  end
end
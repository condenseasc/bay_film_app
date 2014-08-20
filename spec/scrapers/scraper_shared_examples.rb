require 'spec_helper'

RSpec.shared_examples 'a scraper' do
  let(:scraper) { described_class.new }

  before(:all) do
    @scraper = described_class.new
    @scraper.make_series
    @scraper.make_events
  end

  it 'initializes successfully' do
    expect(@scraper.doc.class).to eq(Nokogiri::HTML::Document)
  end

  describe '#make_series' do
    it 'returns @series' do
      expect(@scraper.make_series).to eq(scraper.series)
    end

    it 'populates @series' do
      expect(@scraper.series.length).to be > 0
    end

    it 'makes series objects, inheriting from ScrapedSeries' do
      expect(@scraper.series.first.class.superclass).to eq(ScrapedSeries)
    end
  end

  describe '#make_events' do
    it 'returns @events' do 
      expect(@scraper.make_events).to eq(scraper.events)
    end

    it 'populates @events' do
      expect(@scraper.events.length).to be > 0
    end

    it 'makes event objects, inheriting from ScrapedEvent' do
      expect(@scraper.events.first.class.superclass).to eq(ScrapedEvent)
    end
  end
end

# scrapers - > [PfaScraper, ]

RSpec.describe 'PfaScraper' do
  it_behaves_like 'a scraper'
end

require 'scrape/ybca/ybca_scraper'
require 'scrape/ybca/ybca_series'
require 'scrape/ybca/ybca_event'
require 'scrapers/scraper_shared_examples'

RSpec.describe YbcaScraper do

  # it_behaves_like 'a scraper'

  before(:context) { @scraper = YbcaScraper.new }

  context 'after making series and events' do
    before(:context) { @scraper.make_series; @scraper.make_events }

    it 'holds YbcaSeries' do
      expect(@scraper.series.all? { |s| s.class == YbcaSeries }).to be(true)
    end

    it 'holds YbcaEvents' do
      expect(@scraper.events.all? { |e| e.class == YbcaEvent }).to be(true)
    end

    context 'with events inside and outside series' do
      before(:context) do
        @e_alone          = @scraper.events.select { |e| e.series == nil }
        @e_alone_set      = @e_alone.map( &:url ).to_set

        @e_in_series      = @scraper.events.select { |e| e.series != nil }
        @e_in_series_set  = @e_in_series.map( &:url ).to_set

        @e_in_ybca_series = @scraper.events.select do |e|
          e.series != nil && e.series.first.class == YbcaSeries
        end
      end

      it 'has more than zero events without series' do
        puts "Events in YBCA without Series: #{@e_alone.size}"
        expect( @e_alone.size ).to be > 0
      end

      it 'keeps only unique events, by url' do
        puts "Unique Events in YBCA without Series: #{@e_alone_set.size}"
        expect( @e_alone.size ).to eq( @e_alone_set.size )
      end

      it 'has proper series on events in series' do
        expect( @e_in_series.size ).to eq( @e_in_ybca_series.size )
      end


      it 'only has these two groups, kept separate' do
        unique_event_total = @e_alone_set.size + @e_in_series_set.size
        expect( unique_event_total ).to eq(@scraper.events.size)
      end

      it 'has no overlap between these events' do
        expect( @e_alone_set.disjoint? @e_in_series_set ).to be(true)
      end

    end
  end
end



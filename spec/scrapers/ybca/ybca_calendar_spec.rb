require 'spec_helper'
require 'scrape/ybca/ybca_calendar'

RSpec.describe YbcaCalendar do

  context 'with one still, in a calendar' do
    def calendar_scraper
      YbcaCalendar.new('http://www.ybca.org/lest-we-forget', 
        path:'spec/scrapers/ybca/example_ybca_calendar.html',
        log_tags:['ybca_topic_spec', :timestamp, :test]
        )
    end

    context 'after calling #scrape' do
      before(:context) { @calendar_scraper = calendar_scraper; @calendar_scraper.scrape }

      it 'has correct title' do
        expect( @calendar_scraper.record.title ).to eq('Lest We Forget')
      end

      it 'has correct subtitle' do
        expect( @calendar_scraper.record.subtitle ).to eq('Remembering Radical San Francisco')
      end

      it 'has correct body' do
        re = /^<p><span><span>In the current state of profound, painful transition in San Francisco \(income/
        expect( @calendar_scraper.record.body ).to match( re )
      end

      describe 'image_scrapers' do
        before(:context) { @image = @calendar_scraper.image_scrapers.first.record }
        it 'has correct number of ImageScrapers' do
          expect(@calendar_scraper.image_scrapers.size).to be 1
        end

        it 'has correct title' do
          t = "Alcatraz is not an Island by James Fortier, Courtesy Diamond Island Productions"
          expect(@image.title).to eq( t )
        end

        it 'has correct alt' do
          a = "Alcatraz is not an Island by James Fortier, Courtesy Diamond Island Productions" 
          expect(@image.alt).to eq( a )
        end
      end
    end
  end
end
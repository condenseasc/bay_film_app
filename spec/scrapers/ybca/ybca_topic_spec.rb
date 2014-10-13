require 'spec_helper'
require 'scrape/ybca/ybca_calendar'
require 'scrape/ybca/ybca_topic'

RSpec.describe YbcaTopic do

  # before(:example) { @topic.log_tags = log_tags:['ybca_topic_spec', :timestamp, :test] if @topic}

  context 'with one still, in a calendar' do
    def topic
      YbcaTopic.new( 'http://www.ybca.org/take-this-hammer', 
        path:'spec/scrapers/ybca/example_ybca_topic.html', 
        calendar_scraper: YbcaCalendar.new('http://www.ybca.org/lest-we-forget', 
          path:'spec/scrapers/ybca/example_ybca_calendar.html',
          log_tags:['ybca_topic_spec', :timestamp, :test]
          ),
        log_tags:['ybca_topic_spec', :timestamp, :test] 
        )
    end

    context 'after calling #scrape' do
      before(:context) { @topic = topic.scrape }

      it ('has non nil title')    { expect( @topic.record.title ).to be_truthy }
      it ('has non nil event')    { expect( @topic.record.events ).to be_truthy }
      it ('has non nil body')     { expect( @topic.record.body ).to be_truthy }
      it ('has non nil subtitle') { expect( @topic.record.subtitle ).to be_truthy }
      it ('has non nil callout')  { expect( @topic.callout ).to be_truthy }

      it 'has correct title' do
        expect( @topic.title ).to eq('Take This Hammer')
      end

      it 'has correct subtitle' do
        expect( @topic.subtitle ).to eq('Directed by Richard O. Moore')
      end

      it 'has correct body' do
        re = /^<p><span><span>See and hear author and activist James Baldwin meet with black residents of the Bayview\/Hunter’s/
        expect( @topic.body ).to match( re )
      end

      it 'has correct time' do
        Time.zone = "Pacific Time (US & Canada)"
        t = Time.zone.local(2014, 10, 26, 14)
        expect(@topic.record.events.first.time).to eq( t )
      end

      it('has correct title') { expect(@topic.title).to eq('Take This Hammer') }
      it('has correct title') { expect(@topic.title).to eq('Take This Hammer') }


      describe 'calendar' do
        before(:example) { @topic.save }
        it 'has the right calendar' do
          expect(@topic.record.calendar.title).to eq('Lest We Forget')
        end
      end
    end
  end

  context 'with several images, three showtimes, and no calendar' do
    def topic
      YbcaTopic.new( 'http://www.bamybca.berkeley.edu/film/FN20720', 
        path:'spec/scrapers/ybca/example_ybca_topic_sol_lewitt.html',
        log_tags:['ybca_topic_spec', :timestamp, :test]
        )
    end

    context 'after calling #scrape' do
      before(:context) { @topic = topic.scrape }

      it ('has non nil title')    { expect( @topic.title ).to be_truthy }
      it ('has non nil events')   { expect( @topic.record.events ).to be_truthy }
      it ('has non nil body')     { expect( @topic.body ).to be_truthy }
      it ('has non nil subtitle') { expect( @topic.subtitle ).to be_truthy }
      it ('has non nil callout')  { expect( @topic.callout ).to be_truthy }

      it 'has correct title'do
        expect(@topic.title).to eq('Sol Lewitt')
      end

      it 'has correct subtitle' do
        expect( @topic.subtitle ).to eq('A film by Chris Teerink')
      end

      it 'has correct body' do
        re = /^<p><span><span>“Conceptual artists leap to conclusions logic cannot reach,” said Sol LeWitt/
        expect( @topic.body ).to match( re )
      end

      describe 'its calendar' do
        it 'comes up nil' do
          expect(@topic.calendar_scraper).to be(nil)
        end
      end
    end
  end
end
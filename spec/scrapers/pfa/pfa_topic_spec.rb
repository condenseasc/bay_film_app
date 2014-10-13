  require 'spec_helper'
  require 'scrape/pfa/pfa_calendar'
  require 'scrape/pfa/pfa_topic'

RSpec.describe PfaTopic do

  before(:example) { @topic.log_tags = ['pfa_topic_spec', :timestamp, :test] if @topic}

  context 'with image' do
    def topic
      PfaTopic.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
        path:'spec/scrapers/pfa/example_pfa_topic.html', 
        calendar_scraper: PfaCalendar.new('http://www.bampfa.berkeley.edu/filmseries/ray', 
          path:'spec/scrapers/pfa/example_pfa_calendar.html'
        ) 
      )
    end

    context 'after calling #scrape' do
      before(:context) { @topic = topic.scrape }

      it ('has non nil title')    { expect( @topic.title ).to be_truthy }
      it ('has non nil events')   { expect( @topic.events ).to be_truthy }
      it ('has non nil body')     { expect( @topic.body ).to be_truthy }
      it ('has non nil callout')  { expect( @topic.callout ).to be_truthy }

      it('has the right title') { expect(@topic.title).to eq('The Chess Players') }

    end
  end

  context 'without image' do
    def topic
      PfaTopic.new( 'http://www.bampfa.berkeley.edu/film/FN20720', 
        path:'spec/scrapers/pfa/example_pfa_topic_no_img.html', 
        calendar_scraper: PfaCalendar.new('http://www.bampfa.berkeley.edu/filmseries/ray', 
          path:'spec/scrapers/pfa/example_pfa_calendar.html'
        )
      )
    end

    context 'after calling #scrape' do
      before(:context) { @topic = topic.scrape }

      it ('has non nil title')    { expect( @topic.title ).to be_truthy }
      it ('has non nil events')   { expect( @topic.events ).to be_truthy }
      it ('has non nil body')     { expect( @topic.body ).to be_truthy }
      # it ('has non nil subtitle') { expect( @topic.subtitle ).to be_truthy }
      it ('has non nil callout')  { expect( @topic.callout ).to be_truthy }

      it('has the right title') { expect(@topic.title).to eq('Sikkim') }
    end
  end
end
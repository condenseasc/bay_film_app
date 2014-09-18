  require 'spec_helper'
  require 'scrape/pfa/pfa_series'
  require 'scrape/pfa/pfa_event'

RSpec.describe PfaEvent do

  before(:example) { @event.log_tags = ['pfa_event_spec', :timestamp, :test] if @event}

  let(:scraped_event) do 
    PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
      path:'spec/scrapers/pfa/example_pfa_event.html')
  end
  
  let(:scraped_event_with_still) { scraped_event }

  let(:scraped_event_with_series) do 
    PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
      path:'spec/scrapers/pfa/example_pfa_event.html', 
      series:[ PfaSeries.new('http://www.bampfa.berkeley.edu/filmseries/ray', path:'spec/scrapers/pfa/example_pfa_series.html') ] 
    )
  end

  let(:scraped_event_without_still) do 
    PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20720', 
      path:'spec/scrapers/pfa/example_pfa_event_no_img.html', 
      series:[ PfaSeries.new('http://www.bampfa.berkeley.edu/filmseries/ray', path:'spec/scrapers/pfa/example_pfa_series.html') ] )
  end

  context 'with image' do
    def event
      PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
        path:'spec/scrapers/pfa/example_pfa_event.html', 
        series:[ PfaSeries.new('http://www.bampfa.berkeley.edu/filmseries/ray', 
          path:'spec/scrapers/pfa/example_pfa_series.html') ] )
    end

    context 'after calling #scrape' do
      before(:context) { @event = event.scrape }

      it ('has non nil title')        { expect( @event.title ).to be_truthy }
      it ('has non nil time')         { expect( @event.time ).to be_truthy }
      it ('has non nil description')  { expect( @event.description ).to be_truthy }
      it ('has non nil short_credit') { expect( @event.short_credit ).to be_truthy }
      it ('has non nil announcement') { expect( @event.announcement ).to be_truthy }

      it('has the right title') { expect(@event.title).to eq('The Chess Players') }

    end
  end

  context 'with image' do
    def event
      PfaEvent.new( 'http://www.bampfa.berkeley.edu/film/FN20720', 
        path:'spec/scrapers/pfa/example_pfa_event_no_img.html', 
        series:[ PfaSeries.new('http://www.bampfa.berkeley.edu/filmseries/ray', 
          path:'spec/scrapers/pfa/example_pfa_series.html') ] )
    end

    context 'after calling #scrape' do
      before(:context) { @event = event.scrape }

      it ('has non nil title')        { expect( @event.title ).to be_truthy }
      it ('has non nil time')         { expect( @event.time ).to be_truthy }
      it ('has non nil description')  { expect( @event.description ).to be_truthy }
      it ('has non nil short_credit') { expect( @event.short_credit ).to be_truthy }
      it ('has non nil announcement') { expect( @event.announcement ).to be_truthy }

      it('has the right title') { expect(@event.title).to eq('Sikkim') }
    end
  end
end
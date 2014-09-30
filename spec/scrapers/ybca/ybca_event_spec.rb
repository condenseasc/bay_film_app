# require 'spec_helper'
# require 'scrape/ybca/ybca_series'
# require 'scrape/ybca/ybca_event'

# RSpec.describe YbcaEvent do

#   before(:example) { @event.log_tags = ['ybca_event_spec', :timestamp, :test] if @event}

#   context 'with one still, one series' do
#     def event
#       YbcaEvent.new( 'http://www.ybca.org/take-this-hammer', 
#         path:'spec/scrapers/ybca/example_ybca_event.html', 
#         series:[ YbcaSeries.new('http://www.ybca.org/lest-we-forget', 
#           path:'spec/scrapers/ybca/example_ybca_series.html') ] )
#     end

#     context 'after calling #scrape' do
#       before(:context) { @event = event.scrape }

#       it ('has non nil title')    { expect( @event.title ).to be_truthy }
#       it ('has non nil time')     { expect( @event.time ).to be_truthy }
#       it ('has non nil body')     { expect( @event.body ).to be_truthy }
#       it ('has non nil subtitle') { expect( @event.subtitle ).to be_truthy }
#       # it ('has non nil announcement') { expect( @event.announcement ).to be_truthy }

#       it 'has correct title' do
#         expect( @event.title ).to eq('Take This Hammer')
#       end

#       it 'has correct subtitle' do
#         expect( @event.subtitle ).to eq('Directed by Richard O. Moore')
#       end

#       it 'has correct body' do
#         re = /^<p><span><span>See and hear author and activist James Baldwin meet with black residents of the Bayview\/Hunter’s/
#         expect( @event.body ).to match( re )
#       end

#       it 'has correct time' do
#         Time.zone = "Pacific Time (US & Canada)"
#         t = Time.zone.local(2014, 10, 26, 14)
#         expect(@event.time).to eq( t )
#       end

#       it('has correct title') { expect(@event.title).to eq('Take This Hammer') }
#       it('has correct title') { expect(@event.title).to eq('Take This Hammer') }

#       describe 'series' do
#         it 'has the right series' do
#           expect(@event.series.first.title).to eq('Lest We Forget')
#         end
#       end
#     end
#   end

#   context 'with several images, three showtimes, and no series' do
#     def event
#       YbcaEvent.new( 'http://www.bamybca.berkeley.edu/film/FN20720', 
#         path:'spec/scrapers/ybca/example_ybca_event_sol_lewitt.html')
#     end

#     context 'after calling #scrape' do
#       before(:context) { @event = event.scrape }

#       it ('has non nil title')    { expect( @event.title ).to be_truthy }
#       it ('has non nil time')     { expect( @event.time ).to be_truthy }
#       it ('has non nil body')     { expect( @event.body ).to be_truthy }
#       it ('has non nil subtitle') { expect( @event.subtitle ).to be_truthy }
#       it ('has non nil callout')  { expect( @event.callout ).to be_truthy }

#       it 'has correct title'do
#         expect(@event.title).to eq('Sol Lewitt')
#       end

#       it 'has correct subtitle' do
#         expect( @event.subtitle ).to eq('A film by Chris Teerink')
#       end

#       it 'has correct body' do
#         re = /^<p><span><span>“Conceptual artists leap to conclusions logic cannot reach,” said Sol LeWitt/
#         expect( @event.body ).to match( re )
#       end

#       describe 'its series' do
#         it 'comes up nil' do
#           expect(@event.series).to be(nil)
#         end
#       end
#     end
#   end
# end
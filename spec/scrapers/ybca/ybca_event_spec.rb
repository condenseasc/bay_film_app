# require 'spec_helper'
# require 'scrape/base/scraped_series'
# require 'scrape/base/scraped_event'
# require 'scrape/base/scraped_event'
# # require 'scrape/base/venue_scraper'
# # require 'scrape/ybca/ybca_scraper'
# require 'scrape/ybca/ybca_series'
# require 'scrape/ybca/ybca_event'
# require 'local_resource'

# RSpec.shared_examples 'Ybca Event' do
#   after(:example) { Event.destroy_all; Series.destroy_all}
#   describe 'attributes' do
#     context 'after calling #scrape' do
#       it ('has non nil title')        { expect( @e.title ).to be_truthy }
#       it ('has non nil time')         { expect( @e.time ).to be_truthy }
#       it ('has non nil description')  { expect( @e.description ).to be_truthy }
#       it ('has non nil show_credits') { expect( @e.show_credits ).to be_truthy }
#       it ('has non nil show_notes')   { expect( @e.show_notes ).to be_truthy }
#     end
#   end

#   describe '#save_record_with_associations' do 
#     before(:example) { @e.scrape; @e.save_record_with_associations }
#     context 'with a unique record' do
#       it 'creates a new record' do
#         @e.save_record_with_associations
#         # YbcaEvent.create_record(@e)
#         expect(Event.count).to be(1)
#       end
#     end
#   end
# end 

# RSpec.shared_context 'Local YbcaEvent' do
#   before(:all) do
#     class LocalYbcaSeries < YbcaSeries
#       def initialize
#         @venue = YbcaSeries.venue
#         @series = Series.find_or_create_by(title: 'Fall 2014', venue: YbcaSeries.venue)
#       end
#     end

#     class LocalYbcaEvent < YbcaEvent
#       def initialize(path, url, series)
#         @url = url
#         @doc = make_doc_from_file(path, url)
#         @series = [LocalYbcaSeries.new]
#         @venue = YbcaEvent.venue
#         @logger = ActiveSupport::TaggedLogging.new(Logger.new('log/scrape_test.log')).extend(Scrape::Logging)
#         @log_tags = ['ybca_event_spec', :timestamp]

#       end
#     end
#   end 
# end

# RSpec.describe 'YbcaEvent Offline With Image' do
#   include_context 'Local YbcaEvent'
#   after(:example) { Event.destroy_all; Series.destroy_all}

#   before(:all) do
#    @e = LocalYbcaEvent.new('spec/scrapers/ybca/example_ybca_event.html', 
#     'http://www.ybca.org/take-this-hammer',
#     LocalYbcaSeries.new)
#   end
#   before(:context) { @e.scrape }

#   it_behaves_like 'Ybca Event'
#   it 'has the right title' do
#     expect(@e.title).to eq('Take This Hammer')
#   end

#   describe 'stills' do
#     it 'has non nil stills' do
#       expect( @e.stills.empty? ).to be(false)
#     end

#     it 'has ScrapedStills in its stills' do
#       expect( @e.stills.first.class ).to eq(ScrapedStill)
#     end 
#   end

#   # describe '#save_record_with_associations' do
#   #   before(:example) { @e.scrape; @e.save_record_with_associations }

#   #   it 'saves an event' do
#   #     expect(Event.count).to eq(1)
#   #   end
#   # end
# end

# # RSpec.describe 'YbcaEvent Offline No Image' do
# #   include_context 'Local YbcaEvent'
# #   after(:example) { Event.destroy_all; Series.destroy_all}
# #   before(:all) do
# #    @e = LocalYbcaEvent.new('spec/scrapers/Ybca/example_Ybca_event_no_img.html', 
# #     'http://www.ybca.org/take-this-hammer',
# #     LocalYbcaSeries.new)
# #   end
# #   before(:context) { @e.scrape }

# #   it_behaves_like 'Ybca Event'

# #   describe 'stills' do
# #     it 'has no stills' do
# #       expect( @e.stills.empty? ).to be(true)
# #     end
# #   end
# # end
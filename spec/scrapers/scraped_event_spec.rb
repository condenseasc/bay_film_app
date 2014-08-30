# require 'spec_helper'
# require 'scrapers/base_classes/scraped_event'

# RSpec.describe 'ScrapedEvent' do
#   before(:all) do
#     class ScrapedEventStub < ScrapedEvent
#       def initialize(title, time, venue)
#         @title = title
#         @time = time
#         @venue = venue
#         @logger = VenueScraper.logger
#       end
#     end
#   end

#   let( :event ) { FactoryGirl.build(:event) }
#   let( :venue ) { FactoryGirl.build(:venue) }
#   let( :scraped_event) { ScrapedEvent.new }
#   subject  { event }

#   describe "#save_record" do
#     it "saves new records" do
#       expect(event.new_record?).to be(true)
#       ScrapedEvent.save_record(event, :series)
#       expect(event.new_record?).to be(false)
#     end

#     it "does not save a record with identical attributes" do
#       t = Time.zone.now
#       v = venue
#       v.save

#       # e1 = FactoryGirl.create(:event, title: "test", time: t, venue: v)
#       # e2 = FactoryGirl.build(:event, title: "test", time: t, venue: v)
#       e1 = ScrapedEventStub.new("test", t, v)
#       e2 = ScrapedEventStub.new("test", t, v)

      
#       e1.create_record
#       e2.create_record
#       expect(e2.new_record?).to be(true)


#       # ScrapedEvent.save_record(e2)
#     end

#     it "updates record with new attributes" do
#       event.save
#       a = event.attributes
#       a['description'] = "new description"
#       expect(event.created_at === event.updated_at).to be(true)

#       e = FactoryGirl.build(:event, a)

#       persisted_event = ScrapedEvent.save_scraped_record(e)
#       updated_event = Event.find(event.id)

#       expect(persisted_event === event && persisted_event === updated_event).to be(true)
#       expect(updated_event.description).to eq("new description")
#       expect(updated_event.created_at === updated_event.updated_at).to be(false)
#     end
#   end
# end

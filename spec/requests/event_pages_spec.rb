require 'spec_helper'

describe "EventPages" do
  subject { page }

  let(:venue) { FactoryGirl.create(:venue) }

  before :each do
    event_1 = FactoryGirl.create(:event, venue: venue)
    event_2 = FactoryGirl.create(:event, venue: venue)
    # let(:event_1) { FactoryGirl.create(:event, venue: venue) }
    # let(:event_2) { FactoryGirl.create(:event, venue: venue) }
  end

  # before :each do 
  #   venue = FactoryGirl.create!(:venue)
  #   event_1 = FactoryGirl.create!(:event)
  #   event_2 = FactoryGirl.create!(:event)

  #   venue.events<<(event_1, event_2)
  # end

  
  # it "has correct links on home page" do
  #   visit root_path
  #   click_link 'Events'
  #   page.should have_title('Projection Zone | Events')
  # end
end

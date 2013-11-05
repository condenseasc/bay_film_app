require 'spec_helper'

describe "EventPages" do
  before :each do 
    venue = FactoryGirl.create!(:venue)
    event_1 = FactoryGirl.create!(:event)
    event_2 = FactoryGirl.create!(:event)

    venue.events<<(event_1, event_2)
  end

  
  describe "" do
  end
end

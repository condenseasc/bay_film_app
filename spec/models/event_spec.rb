require 'spec_helper'

describe Event do

  describe "validation" do
    before { e1 = Event.new(title: "Breathless", time: Time.new, description: "blah blah") }

    expect( e1 ).to be_valid

    describe "requires a title" do
      expect( e1.title = nil ).not_to be_valid
    end
    
    describe "requires a time" do
      expect( e1.time = nil ).not_to be_valid
    end
  end
end

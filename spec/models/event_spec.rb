require 'spec_helper'

describe Event do

  describe "validation" do

    let( :event ) { FactoryGirl.create(:event) }
    subject  { event }

    it { should be_valid }

    describe "requires a title" do
      before { event.title = nil }
      it { should_not be_valid }
    end
    
    describe "requires a time" do
      before { event.time = nil }
      it { should_not be_valid }
    end

  end
end

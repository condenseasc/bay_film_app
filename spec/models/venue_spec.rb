require 'spec_helper'

describe Venue do
  let(:venue) { FactoryGirl.build :venue }
  subject { venue }

  describe "Validation" do
    it { should be_valid }

    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should respond_to(:street_address) }
    it { should respond_to(:city) }

    it { should respond_to(:events) }

    describe "without a name" do
      before { venue.name = nil }
      it { should_not be_valid }
    end

    describe "with a city outside the bay" do
      before { venue.city = "Kalamazoo" }
      it { should_not be_valid }
    end
  end

  describe "event associations" do
    before { venue.save }
    let!(:near_future_event) do
      FactoryGirl.create(:event, venue: venue, time: Time.now.end_of_hour)
    end
    let!(:distant_future_event) do
      FactoryGirl.create(:event, venue: venue, time: Time.now.end_of_day)
    end

    it "should have the right events in the right order" do
      expect(venue.events.upcoming).to eq([near_future_event, distant_future_event])
    end
  end
end

require 'spec_helper'

describe Venue do

  describe "Validation" do
    let(:venue) { FactoryGirl.create :venue }
    subject { venue }

    it { should be_valid }

    describe "without a name" do
      before { venue.name = nil }
      it { should_not be_valid }
    end

    describe "with a city outside the bay" do
      before { venue.city = "Kalamazoo" }
      it { should_not be_valid }
    end
  end
end

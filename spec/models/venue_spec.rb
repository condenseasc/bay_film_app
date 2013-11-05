require 'spec_helper'

describe Venue do

  describe "Validation" do
    let(:venue) { FactoryGirl.build :venue }
    subject { venue }

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
end

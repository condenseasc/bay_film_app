require 'spec_helper'

describe Event do
  let( :event ) { FactoryGirl.build(:event) }
  let( :venue ) { FactoryGirl.build(:venue) }
  subject  { event }

  it { should respond_to(:title) }
  it { should respond_to(:time) }
  it { should respond_to(:description) }
  it { should respond_to(:venue) }

  describe "validation" do
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

  describe "venue association" do
    before { event.venue = nil }
    it { should_not be_valid }
  end

  describe "scopes" do
    describe "default scope orders by time ascending" do
    end
  end
end

require 'rails_helper'

RSpec.describe Event, :type => :model do

  let( :event )   { build :event }
  subject { event }

  it { is_expected.to be_valid }
  it { is_expected.to respond_to(:time) }

  describe "without time" do
    it 'is not valid' do
      event.time = nil
      expect(event.valid?).to be false
    end
  end

  describe "without a topic" do
    it 'is not valid' do
      event.topic = nil
      expect(event.valid?).to be false
    end
  end
  # it { is_expected.to respond_to(:venue) }

end
require 'rails_helper'

RSpec.describe Event, :type => :model do

  let( :event )   { FactoryGirl.build(:event) }
  let( :series )  { FactoryGirl.build(:series)}
  subject  { event }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:supertitle) }
  it { is_expected.to respond_to(:subtitle) }
  it { is_expected.to respond_to(:callout) }
  it { is_expected.to respond_to(:body) }
  it { is_expected.to respond_to(:footer) }
  it { is_expected.to respond_to(:url) }
  it { is_expected.to respond_to(:admission) }
  it { is_expected.to respond_to(:times) }
  it { is_expected.to respond_to(:venue) }

  describe "venue association" do
    before { event.venue = nil }
    it { should_not be_valid }
  end

  describe "scopes" do
    describe "default scope orders by time ascending" do
    end
  end

  describe "validation" do
    it { is_expected.to be_valid }

    describe "requires a title" do
      before { event.title = nil }
      it { is_expected.not_to be_valid }
    end
  end

  #   describe 'requires an event_time' do
  #     it 'invalid without event' do
  #       event.times = nil
  #       expect(event).not_to be_valid
  #     end

  #     it 'is valid with a series' do
  #       capsule.describables = series
  #       expect(capsule).to be_valid
  #     end
  #   end
  # end

  # describe 'polymorphism' do
  #   context 'with multiple describables' do
  #     def add_to_describables
  #       series.capsule = capsule; series.save
  #       event.capsule  = capsule; event.save
  #     end

  #     it 'is valid' do
  #       add_to_describables
  #       expect(capsule).to be_valid
  #     end

  #     it 'stays inversed' do
  #     end
  #   end
  # end
end
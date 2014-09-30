require 'spec_helper'


describe Series do
  before(:all) { Event.destroy_all; Venue.destroy_all; Series.destroy_all}
  let(:series) { FactoryGirl.build(:series) }
  let(:another_series) { FactoryGirl.build(:series) }
  let(:venue)  { FactoryGirl.create(:venue) }
  subject { series }

  describe "Validations" do
    it { should be_valid }

    describe "title" do
      context 'when nil is invalid' do
        before { series.title = nil }
        it { should_not be_valid }
      end

      context 'shared with another series at some venue' do
        before(:example) do
          @series = FactoryGirl.build(:series).tap do |s|
            s.venue = venue
            s.title = 'test'
          end
          # @series.venue = venue
          # @series.title = 'test'
          @series.save

          @another_series = FactoryGirl.build(:series).tap do |s|
            s.title = @series.title
            s.venue = @series.venue
          end
          # @another_series.title = @series.title
          # @another_series.venue = @series.venue
        end

        it 'is invalid' do
          expect(@another_series).not_to be_valid
        end

        it 'has error message on title' do
          @another_series.valid?
          expect(@another_series.errors[:title].length).to eq(1)
        end

        it 'has the expected error message' do
          @another_series.valid?
          expect(@another_series.errors[:title][0]).to eq('exists in scope [:venue]')
        end
      end
    end
  end
end
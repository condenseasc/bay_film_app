require 'spec_helper'

describe Series do
  let(:series) { FactoryGirl.build(:series) }
  subject { series }

  describe "Validations" do
    it { should be_valid }

    describe "requires a title" do
      before { series.title = nil }
      it { should_not be_valid }
    end
  end
end

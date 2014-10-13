require 'rails_helper'

RSpec.describe Topic, :type => :model do
  let( :event ) { build :event }
  let( :topic ) { build :topic }
  subject {topic}

  it { is_expected.to be_valid }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:supertitle) }
  it { is_expected.to respond_to(:subtitle) }
  it { is_expected.to respond_to(:callout) }
  it { is_expected.to respond_to(:body) }
  it { is_expected.to respond_to(:footer) }
  it { is_expected.to respond_to(:url) }
  # it { is_expected.to respond_to(:admission) }
  # it { is_expected.to respond_to(:times) }
  # it { is_expected.to respond_to(:venue) }

    describe "title" do
      describe "is required for validation" do
        before { topic.save; topic.title = nil }
        it { is_expected.not_to be_valid }
      end
    end
end

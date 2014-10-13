require 'rails_helper'

RSpec.describe Calendar, :type => :model do
  # before(:all) { Event.destroy_all; Venue.destroy_all; Series.destroy_all}
  let(:calendar)          { create :calendar }
  let(:topic_with_events) { create :topic_with_events, events_count: 5 }
  let(:full_calendar )    { create :calendar_with_topics, topics_count: 2, events_count: 3 }
  let(:second_calendar)   { build :calendar }
  subject { calendar }

  def events_since( number = 1 )
    events_array = []
    number.times { |n| events_array.push Event.new( time:(n+1).hours.since ) }
    events_array
  end

  def events_ago( number = 1 )
    events_array = []
    number.times { |n| events_array.push Event.new( time:(n+1).hours.ago ) }
    events_array
  end

  it { is_expected.to be_valid }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:supertitle) }
  it { is_expected.to respond_to(:subtitle) }
  it { is_expected.to respond_to(:callout) }
  it { is_expected.to respond_to(:body) }
  it { is_expected.to respond_to(:footer) }
  it { is_expected.to respond_to(:url) }

  describe 'title' do
    context 'is required' do
      before { calendar.title = nil }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#upcoming_events' do
    it 'only returns upcoming events' do
      calendar.topics << Topic.new(title:'one', events: events_ago(2).concat(events_since(8)) )
      expect(calendar.upcoming_events.length).to be 8
    end
  end

  describe '#all_events' do
    context 'with topic containing events' do

      it 'returns events' do
        expect(full_calendar.all_events.class).to eq(Event::ActiveRecord_Relation) 
      end

      it 'has length of events list' do
        expect(full_calendar.all_events.length).to be 6
      end

      it 'has them ordered by time ASC' do
        event_1 = create :event, time: 1.days.ago
        event_2 = create :event, time: Time.now.advance( hours:1 )
        event_3 = create :event, time: Time.now.advance( hours:2 )
        event_4 = create :event, time: Time.now.advance( hours:3 )

        cal = create :calendar
        cal.topics << Topic.new(title: 'first',  events:[event_1, event_3] )
        cal.topics << Topic.new(title: 'second', events:[event_2, event_4] )

        expect(cal.all_events.to_a).to eq([event_1, event_2, event_3, event_4])
      end
    end
  end
end
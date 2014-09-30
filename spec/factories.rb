FactoryGirl.define do
  factory :event do 
    sequence(:title) { |n| "Napoleon Reel #{n}" }
    venue

    factory :event_with_times do
      ignore do
        event_times_count 1
      end

      after(:build) do |event, evaluator|
        build_list(:event_time, evaluator.event_times_count, event: event)
      end
    end
  end

  factory :event_time do
    sequence(:start) { |n| Time.now.advance(hours: n) }
  end

  # factory :day do
  # end

  factory :venue do
    sequence(:name) { |n| "Cineplex #{n}" }
    description "Lorem ipsum"
    street_address "3849 54th Street"
    city ["Oakland", "Berkeley", "San Francisco"].sample
  end

  factory :series do
    sequence(:title) { |n| "Films from Territory #{n}" }
    body "Lorem ipsum"
  end

  # class WeekSerializer
  #   def initialize
  #   end

  #   def to_json
  #   end
  # end
end
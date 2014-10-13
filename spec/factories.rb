FactoryGirl.define do
  # factory :event do 
  #   sequence(:title) { |n| "Napoleon Reel #{n}" }
  #   venue

  #   factory :event_with_times do
  #     ignore do
  #       event_times_count 1
  #     end

  #     after(:build) do |event, evaluator|
  #       build_list(:event_time, evaluator.event_times_count, event: event)
  #     end
  #   end
  # end

  factory :topic, aliases: [:summary] do 
    sequence(:title) { |n| "Napoleon Reel #{n}" }

    factory :topic_with_events do
      ignore do
        events_count 1
      end
      after(:create) do |topic, evaluator|
        create_list(:event, evaluator.events_count, topic: topic)
      end
    end
  end

  factory :calendar do
    sequence(:title) { |n| "Mock Season #{n} Calendar" }

    factory :calendar_with_topics do
      ignore do
        topics_count 1
        events_count 1
      end
      after(:create) do |calendar, evaluator|
        create_list(:topic_with_events, 
          evaluator.topics_count, 
          events_count: evaluator.events_count, 
          calendar: calendar)
      end
    end
  end

  factory :event do
    sequence(:time) { |n| Time.now.advance(hours: n) }
    topic
  end

  # factory :day do
  # end


  factory :venue do
    sequence(:name) { |n| "Cineplex #{n}" }
    description "Lorem ipsum"
    street_address "3849 54th Street"
    city ["Oakland", "Berkeley", "San Francisco"].sample
  end

  # factory :series do
  #   sequence(:title) { |n| "Films from Territory #{n}" }
  #   body "Lorem ipsum"
  # end

  # class WeekSerializer
  #   def initialize
  #   end

  #   def to_json
  #   end
  # end
end
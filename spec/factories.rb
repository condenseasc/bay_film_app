FactoryGirl.define do
  factory :event do 
    sequence(:title) { |n| "Napoleon Reel #{n}" }
    sequence(:time) { |n| Time.now.advance(hours: n) }
    description "Lorem ipsum"
  end

  factory :venue do
    sequence(:name) { |n| "Cineplex #{n}" }
    description "Lorem ipsum"
    street_address "3849 54th Street"
  end
end
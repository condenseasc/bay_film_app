class Venue < ActiveRecord::Base
  BAY_CITIES = [nil, "Oakland", "Berkeley", "San Francisco"]

  has_many :events
  has_many :series

  validates :name, presence: :true
  validates :city, inclusion: { in: BAY_CITIES, message: "If you have a city, it's got to be on my list. Email me if I need to expand my list."}
end

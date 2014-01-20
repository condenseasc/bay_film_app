class Series < ActiveRecord::Base
  has_many :events
  belongs_to :owner, class_name: "Venue", foreign_key: :venue_id

  validates :title, presence: true
end
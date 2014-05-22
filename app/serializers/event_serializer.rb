class EventSerializer < ActiveModel::Serializer
  attributes :id, :time, :title, :description, :show_credits, :show_notes, :venue_id

  has_one :venue, embed: :objects
  has_many :series, embed: :objects
end
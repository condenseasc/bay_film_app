class EventSerializer < ActiveModel::Serializer
  attributes :id, :time, :title, :description, :venue_id, :series_id

  has_one :venue, embed: :objects
  has_one :series, embed: :objects
end
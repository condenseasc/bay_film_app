class EventSerializer < ActiveModel::Serializer
  attributes :id, :time, :title, :description, :show_credits, :show_notes, :venue_id, :still_url_medium

  has_one :venue, embed: :objects
  has_many :series, embed: :objects

  def still_url_medium
    object.still.url(:feed_medium) if object.still.exists?
  end
end
class EventSerializer < ActiveModel::Serializer
  attributes :id, :time, :title, :description, :short_credit, :full_credits, :announcement, :location_note, :venue_id, :still_url_capsule_medium

  has_one :venue, embed: :objects
  has_many :series, embed: :objects

  def still_url_capsule_medium
    object.stills.first.image.url(:capsule_medium) if object.stills.first && object.stills.first.image.exists?
  end
end
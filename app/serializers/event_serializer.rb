class EventSerializer < ActiveModel::Serializer
  extend Forwardable
  attributes :id, :time, :image_url_capsule_medium, 
                         :title, :supertitle, :subtitle, :callout, :body, :footer
  def_delegators :object_topic, :title, :supertitle, :subtitle, :callout, :body, :footer

  has_one :venue, embed: :objects
  # has_many :series, embed: :objects

  def image_url_capsule_medium
    object.topic.images.first.asset.url(:capsule_medium) if object.topic.images.first && object.topic.images.first.asset.exists?
  end

  def object_topic
    object.topic
  end
end
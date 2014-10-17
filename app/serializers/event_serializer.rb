class EventSerializer < ActiveModel::Serializer
  extend Forwardable
  attributes :id, :time, :image_url_medium, :title, :supertitle, :subtitle, :callout, :body, :footer, :calendar_title
  def_delegators :object_topic, :title, :supertitle, :subtitle, :callout, :body, :footer

  has_one :venue, embed: :objects
  # has_many :series, embed: :objects

  def image_url_medium
    if object.topic && object.topic.images  && object.topic.images.first.asset.exists?
      object.topic.images.first.asset.url(:medium) 
    end
  end

  def calendar_title
    if object.topic.calendar
      object.topic.calendar.title
    end
  end

  def title
    object.topic.title
  end

  def object_topic
    object.topic
  end
end
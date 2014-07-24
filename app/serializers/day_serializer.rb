class DaySerializer < ActiveModel::Serializer
  attributes :id, :date, :events

  def events
    ActiveModel::ArraySerializer.new(object.events, each_serializer: EventSerializer)
  end
end

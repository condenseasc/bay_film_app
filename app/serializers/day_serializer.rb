class DaySerializer < ActiveModel::Serializer
  attributes :id, :events

  def events
    ActiveModel::ArraySerializer.new(object.event_array, each_serializer: EventSerializer)
  end


end

class Day

  def initialize(time)
    @id = day_id(time)
    @event_array = Event.get_day(time).to_a
  end

  attr_reader :id, :event_array

  def day_id(time)
    time.to_formatted_s(:day_id)
  end

  # def read_attribute_for_serialization(key)
  #   self[key]
  # end
  
  # def attributes
  #   {'id' => nil, 'events' => nil}
  # end


  alias :read_attribute_for_serialization :send

end

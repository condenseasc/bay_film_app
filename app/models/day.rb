class Day

  def initialize(time)
    @id = Day.day_id(time)
    @date = Day.day_id_to_time(id)
    @events = Event.get_day(time).to_a
  end

  attr_reader :id, :date, :events

  def self.find(day_id)
    Day.new(Day.day_id_to_time(day_id))
  end

  def self.day_id(time)
    time.to_formatted_s(:day_id)
  end

  def self.day_id_to_time(day_id)
    t = Time.strptime(day_id, '%Y%m%d')
    Time.zone.local(t.year, t.month, t.day)
  end


  alias :read_attribute_for_serialization :send
end

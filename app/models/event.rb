class Event < ActiveRecord::Base
  belongs_to :venue, inverse_of: :events
  belongs_to :topic, inverse_of: :events, dependent: :destroy
  validates :time,  presence: true
  validates :topic, presence: true

  # takes a time object
  def self.get_day(time)
    Event.where("events.time >= :start_time AND events.time <= :end_time",
        start_time: time.beginning_of_day, end_time: time.end_of_day)
  end

  default_scope -> { includes(:topic).order(time: :asc) }

  scope :all_associations, -> { includes(:venue) }
  scope :this_week, -> { 
    Event.where("events.time >= :start_time AND events.time <= :end_time", 
      start_time: Time.zone.now.beginning_of_day, 
      end_time:   Time.zone.now.beginning_of_day.advance(days: 7).end_of_day
    )
  }
  scope :upcoming, -> { 
    Event.where( "events.time >= ?", Time.zone.now.beginning_of_day ) 
  }


  def <=>(event)
    self.time <=> event.time
  end


  ######## LEGACY CODE
  def self.get_active_dates(first, last)
    first_day = parse_date(first).beginning_of_day
    last_day = parse_date(last).end_of_day

    Event.unscoped
      .select("time")
      .distinct("date(time)")
      .where("time >= :start_time AND time <= :end_time",
      start_time: first_day, end_time: last_day)
      .order("time ASC")
  end

  # parses the frontends requests, which come in the form
  # YYYYMMDD
  def self.parse_date(date)
    Time.zone.parse("#{date.slice(0,4)}-#{date.slice(4,2)}-#{date.slice(6,2)}")
  end

  def to_a
    [self]
  end

  def self.get_range_between(first, last)
    first_day = parse_date(first).beginning_of_day
    last_day = parse_date(last).end_of_day

    Event.where("events.time >= :start_time AND events.time <= :end_time",
      start_time: first_day, end_time: last_day)
  end

  def self.get_range(first, days)
    first_day = parse_date(first).beginning_of_day
    last_day = first_day.advance(days: days - 1).end_of_day

    Event.includes(:topic).where("events.time >= :start_time AND events.time <= :end_time",
      start_time: first_day, end_time: last_day)
  end

  def self.get_week(sunday)
    self.get_range(sunday, 7)
  end
end
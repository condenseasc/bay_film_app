class Event < ActiveRecord::Base
  # attr_accessible :title, :time, :description
  belongs_to :venue
  belongs_to :series
  belongs_to :day

  validates :title, presence: true
  validates :time, presence: true
  validates :venue, presence: true

  default_scope -> { order("time ASC") }

  this_morning = Time.zone.now.beginning_of_day
  scope :upcoming, -> { where( "time >= ?", this_morning ) }
  scope :this_week, -> { 
    where "time >= :start_time AND time <= :end_time", 
    start_time: this_morning, end_time: this_morning.advance(days: 7)
  }
  scope :includes_venue_series, -> { includes :venue, :series }

  def self.get_range_between(first, last)
    first_day = parse_date(first)
    last_day = parse_date(last)
    Event.where "time >= :start_time AND time <= :end_time",
      start_time: first_day, end_time: last_day
  end

  def self.get_range(first, days)
    first_day = parse_date(first)
    last_day = first_day.advance(days: days)
    Event.where "time >= :start_time AND time <= :end_time",
      start_time: first_day, end_time: last_day
  end

  def self.get_week(sunday)
    self.get_range(sunday, 7)
  end

  # parses the frontends requests, which come in the form
  # YYYYMMDD
  def self.parse_date(date)
    Time.zone.parse("#{date.slice(0,4)}-#{date.slice(4,2)}-#{date.slice(6,2)}")
  end

  def display_time
    time = self.time
    # Test if it's today, making sure the 
    if time.day == Time.zone.now.day
      time.to_s(:today)
    elsif time.year === Time.zone.now.year
      time.to_s(:with_month)
    else
      time.to_s(:with_year)
    end
  end
end

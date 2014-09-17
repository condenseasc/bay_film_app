class Event < ActiveRecord::Base
  # attr_accessible :title, :time, :description
  belongs_to :venue, inverse_of: :events
  has_many :stills, inverse_of: :event
  has_and_belongs_to_many :series

  validates :time, presence: true
  validates :venue, presence: true
  # validates :series_id, uniqueness: true
  validates :title, presence: true,
                    uniqueness: { scope: [:time, :venue_id], 
                      message: 'exists in scope [:time, :venue]' }



# Can't use this if I don't have a Capsule model!! In the meantime repetition is legitimate.
# # validates that there aren't multiple entries with the same description/title combo... slow?
#   validates :description, 
#   on: :update,
#   uniqueness: {scope: [:title]}

# have a separate validator for updates, which deals withs updating description, time, w/e


  default_scope -> { order("time ASC") }

  this_morning = Time.zone.now.beginning_of_day
  scope :upcoming, -> { where( "time >= ?", this_morning ) }
  scope :this_week, -> { 
    where "time >= :start_time AND time <= :end_time", 
    start_time: this_morning, end_time: this_morning.advance(days: 7).end_of_day
  }
  scope :includes_venue_series, -> { includes :venue, :series }

  def self.get_range_between(first, last)
    first_day = parse_date(first).beginning_of_day
    last_day = parse_date(last).end_of_day
    Event.where "time >= :start_time AND time <= :end_time",
      start_time: first_day, end_time: last_day
  end

  def self.get_range(first, days)
    first_day = parse_date(first).beginning_of_day
    last_day = first_day.advance(days: days - 1).end_of_day
    Event.where "time >= :start_time AND time <= :end_time",
      start_time: first_day, end_time: last_day
  end

  def self.get_week(sunday)
    self.get_range(sunday, 7)
  end

  # takes a time object
  def self.get_day(time)
    Event.where "time >= :start_time AND time <= :end_time",
      start_time: time.beginning_of_day, end_time: time.end_of_day
  end

  # def get_range(first, days)
  #   first_day = first.beginning_of_day
  #   last_day = first_day.advance(days: days - 1).end_of_day
  #   Event.where "time >= :start_time AND time <= :end_time",
  #     start_time: first_day, end_time: last_day
  # end  

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
end

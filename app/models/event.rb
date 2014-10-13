class Event < ActiveRecord::Base
  belongs_to :venue, inverse_of: :events
  belongs_to :topic, inverse_of: :events, dependent: :destroy
  validates :time,  presence: true
  validates :topic, presence: true
  # , 
  #                   uniqueness: { scope: [:event], 
  #                                 message: 'exists in scope [:event_id]' }
                                  
  # validate :topic, presence: true


  # takes a time object
  def self.get_day(time)
    Event.includes(:topic)
      .where("events.time >= :start_time AND events.time <= :end_time",
        start_time: time.beginning_of_day, end_time: time.end_of_day)
  end

  default_scope -> { includes(:topic).order(time: :asc) }
  scope :all_associations, -> { includes(:venue, :topic) }
  scope :this_week, -> { 
    includes(:topic)
    .where("events.time >= :start_time AND events.time <= :end_time", 
      start_time: Time.zone.now.beginning_of_day, 
      end_time:   Time.zone.now.beginning_of_day.advance(days: 7).end_of_day
    )
  }
  scope :upcoming, -> { 
    includes(:topic)
    .where( "events.time >= ?", Time.zone.now.beginning_of_day ) 
  }


  def <=>(event)
    self.time <=> event.time
  end
end


# class Event < ActiveRecord::Base
#   # attr_accessible :title, :time, :description
#   belongs_to :venue, inverse_of: :events
#   has_many :stills, inverse_of: :event
#   has_many :event_times
#   has_and_belongs_to_many :series


#   validates_associated :event_times
#   validates :venue, presence: true
#   validates :title, presence: true
#   # 9/26/2014
#   # Illegal - undefined method `event_id' for #<Event:0x007fd70a5c1e60>
#   # validates :title, uniqueness: { scope: [:event_times, :venue_id], 
#   #                     message: 'exists in scope [:event_time, :venue]' }


#   # Can't use this if I don't have a Capsule model!! In the meantime repetition is legitimate.
#   # # validates that there aren't multiple entries with the same description/title combo... slow?
#   #   validates :description, 
#   #   on: :update,
#   #   uniqueness: {scope: [:title]}

#   # have a separate validator for updates, which deals withs updating description, time, w/e



  # scope :includes_venue_series, -> { includes :venue, :series }

  # alias_method :times,  :event_times
  # alias_method :times=, :event_times=

#   def to_a
#     [self]
#   end

#   def self.get_range_between(first, last)
#     first_day = parse_date(first).beginning_of_day
#     last_day = parse_date(last).end_of_day
#     Event.includes(:event_times)
#       .where("event_times.start >= :start_time AND event_times.start <= :end_time",
#         start_time: first_day, end_time: last_day)
#       .references(:event_times)
#   end

#   def self.get_range(first, days)
#     first_day = parse_date(first).beginning_of_day
#     last_day = first_day.advance(days: days - 1).end_of_day
#     Event.includes(:event_times)
#       .where("event_times.start >= :start_time AND event_times.start <= :end_time",
#         start_time: first_day, end_time: last_day)
#       .references(:event_times)
#   end

#   def self.get_week(sunday)
#     self.get_range(sunday, 7)
#   end

#   # def get_range(first, days)
#   #   first_day = first.beginning_of_day
#   #   last_day = first_day.advance(days: days - 1).end_of_day
#   #   Event.where "time >= :start_time AND time <= :end_time",
#   #     start_time: first_day, end_time: last_day
#   # end  

#   def self.get_active_dates(first, last)
#     first_day = parse_date(first).beginning_of_day
#     last_day = parse_date(last).end_of_day

#     EventTimes.unscoped
#       .select("start")
#       .distinct("date(start)")
#       .where("start >= :start_time AND start <= :end_time",
#       start_time: first_day, end_time: last_day)
#       .order("start ASC")

#     # Event.unscoped
#     #   .select("time")
#     #   .distinct("date(time)")
#     #   .where("time >= :start_time AND time <= :end_time",
#     #   start_time: first_day, end_time: last_day)
#     #   .order("time ASC")
#   end

#   # parses the frontends requests, which come in the form
#   # YYYYMMDD
#   def self.parse_date(date)
#     Time.zone.parse("#{date.slice(0,4)}-#{date.slice(4,2)}-#{date.slice(6,2)}")
#   end
# end

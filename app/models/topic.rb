require 'exceptions'

class Topic < Document
  has_many :events, inverse_of: :topic
  has_many :images, as: :imageable
  belongs_to :calendar, inverse_of: :topics, foreign_key: 'parent_id'

  validates :title, presence: true
  validates_associated :events

  default_scope -> { includes :images }

  def times
    # Event.joins(:topic).where(topic: self).order(time: :asc).map { |e| e.time }
    events.sort.map { |e| e.time }
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


#   default_scope -> { includes(:event_times).order("event_times.start ASC").references(:event_times) }

#   this_morning = Time.zone.now.beginning_of_day
#   scope :upcoming, -> { includes(:event_times).where( "event_times.start >= ?", this_morning ).references(:event_times) }
#   scope :this_week, -> { 
#     includes(:event_times)
#     .where("event_times.start >= :start_time AND event_times.start <= :end_time", 
#       start_time: this_morning, end_time: this_morning.advance(days: 7).end_of_day)
#     .references(:event_times)
#   }
#   scope :includes_venue_series, -> { includes :venue, :series }

#   alias_method :times,  :event_times
#   alias_method :times=, :event_times=

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

#   # takes a time object
#   def self.get_day(time)
#     Event.includes(:event_times)
#       .where("event_times.start >= :start_time AND event_times.start <= :end_time",
#         start_time: time.beginning_of_day, end_time: time.end_of_day)
#       .references(:event_times)
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

class Event < ActiveRecord::Base
  # attr_accessible :title, :time, :description
  belongs_to :venue
  belongs_to :series

  validates :title, presence: true
  validates :time, presence: true
  validates :venue, presence:true

  this_morning = Time.zone.now.beginning_of_day
  scope :upcoming, -> { where( "time >= ?", this_morning ).order( "time ASC") }
  scope :this_week, -> { 
    where "time >= :start_time AND time <= :end_time", 
    start_time: this_morning, end_time: this_morning.advance(days: 7)
  }
  scope :includes_venue_series, -> { includes :venue, :series }

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

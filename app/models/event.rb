class Event < ActiveRecord::Base
  # attr_accessible :title, :time, :description
  belongs_to :venue
  belongs_to :series

  validates :title, presence: true
  validates :time, presence: true
  validates :venue, presence:true

  scope :upcoming, -> { where( "time > ?", Time.zone.now).order( "time ASC") }

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

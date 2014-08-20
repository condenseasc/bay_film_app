require 'image_comparison'

class Event < ActiveRecord::Base
  # attr_accessible :title, :time, :description
  belongs_to :venue
  has_and_belongs_to_many :series
  has_attached_file :still, styles: { feed_medium: "300" }

  validates_attachment :still, 
    content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] }

  validates :title, presence: true
  validates :time, presence: true
  validates :venue, presence: true

  # validates :title, uniqueness: {scope: [:time, :venue_id],
  #   message: "already exists at this screening time and venue"}

  validates_uniqueness_of :title, scope: [:time, :venue_id],
    message: "already exists at this screening time and venue"


# what was this for?
  validates :description, 
  on: :update,
  uniqueness: {scope: [:title]}

# validate that its time, title, and venue are unique. 
# if not, check if their descriptions are the same.
# if they're different, update the pre-existing event


# have a separate validator for updates, which deals withs updating description, time, w/e

# with images, check if the image is the same as the existing one,
# 

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

  # takes two activerecord objects, returns a hash, ready to "update"
  def self.attribute_difference(persisted_record, new_record)
    updated_attr_hash = {}
    excluded = %w{id time title venue created_at updated_at still}
    updated_keys = new_record.attributes.keys.delete_if do |a|
      excluded.any? { |x| a.match(x) } ||
        persisted_record["#{a}"] === new_record["#{a}"]
    end

    updated_keys.each { |a| updated_attr_hash["#{a}".to_sym] = new_record["#{a}"] }
    updated_attr_hash
  end

  # Takes relations (not records) and returns the difference as an array of records
  def self.association_difference(persisted_relation, new_relation)
    new_relation.to_a.delete_if do |n|
      persisted_relation.any? { |p| p.id == n.id }
    end
  end

  def save_still_if_new_or_larger(image)
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    e = self
    log_note = (e.venue.abbreviation || e.venue.name).upcase

    if !e
      return nil
    elsif !e.still? || !(ImageComparison.duplicate_image?(e.still.path, image.path) && 
      (e.still.size >= image.size))
    
      e.still = image.open
      e.save

      logger.tagged("SCRAPER", "#{log_note}", "STILL", "SAVE_NEW") {
        logger.info "#{e.title}, #{e.id}"
      }
      e
    else
      logger.tagged("SCRAPER", "#{log_note}", "STILL", "DO_NOTHING") {
        logger.info "#{e.title}, #{e.id}"
      }
      nil
    end
  end
end

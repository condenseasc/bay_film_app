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

  validates :title, uniqueness: {scope: [:time, :venue],
    message: "title already exists at this screening time and venue"}

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
  
  def self.get_week(sunday)
    self.get_range(sunday, 7)
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

# first method --> see if they have different associations
# to_a doesn't work on a single record
# AH ISSSUUUUEEEE!!!! I pass in plain records from Series.find from the scraper
# as the new_relation, which gives me a
# persisted_relation --> event.send(series) --> Series::ActiveRecord_Associations_CollectionProxy
# new_relation --> Series.find(x) ---> Series
# THE LATTER because I haven't been able to do 
  def self.association_difference(persisted_relation, new_relation)
    new_relation.to_a.delete_if do |n|
      persisted_relation.any? { |p| p.id == n.id }
    end
  end

  def self.association_hash_difference(persisted_record, new_record, model_hash)

  end

  # def self.association_difference(existing, revised, association)
  #   existing_collection = existing.send(association).map { |a| a.id }
  #   revision_collection = revision.send(association).map { |a| a.id }

  #   revision_collection.delete_if do |r|
  #     existing_collection.any? { |e| e === r }
  #   end
  # end

  # def self.association_difference(persisted_relation, new_relation)
  #   persisted_collection = persisted_relation.map(&:id)
  #   new_collection = new_relation.map(&:id)

  #   new_collection.delete_if do |r|
  #     persisted_collection.any? { |e| e === r }
  #   end
  # end

  def self.save_scraped_record(record, *associations)
    e = record
    log_note = (e.venue.abbreviation || e.venue.name).upcase
    if e.valid?
      Event.save!(e)
      # Two reasons for associations being added separately.
      # first, associations with join tables don't show up as attributes, so my filter ignores them
      # second, Series breaks activerecord because it looks like it's plural
      # (!) or somehow because it's many-to-many...
      # Either way it wants an array of series, breaks looking for "each"

      logger.tagged("SCRAPER", "#{log_note}", "SAVE_NEW") {
        logger.info "Saved new event with id: #{e.id}"
      }
    elsif e.errors.size === 1 &&
      e.errors[:title][0] === "title already exists at this screening time and venue"
      logger.tagged("SCRAPER", "#{log_note}", "EVENT_EXISTS") {
        logger.info "Event exists -> #{e.title}, #{e.time.strftime("%m/%d/%Y %H:%M")}, #{e.venue.abbreviation || e.venue.name}"
      }
      # Paranoid? Checking if something screwy led to duplicate persisted records.
      # Maybe split this into a different rake task with teeth to check and delete them?
      persisted_events = Event.where(title: e.title, time: e.time, venue: e.venue)
      if persisted_events.length > 1
        logger.tagged("SCRAPER", "#{log_note}", "MULTIPLE_DUPLICATES_FOUND") {
          logger.warn "Duplicates -> #{persisted_events.each { |e| print e.id + "; "}}"
        }
        raise DuplicateRecordError.new, "Multiple duplicate records for event"
      else
        persisted_event = persisted_events[0]
      end

      # Get a hash of attributes and a hash of :association => [records]
      attr_difference = Event.attribute_difference(persisted_event, e)

      associations_hash = {}
      associations.each do |name|
        associations_hash[name] = Event.association_difference(persisted_event.send(name), e.send(name))
        associations_hash.delete(name) if associations_hash[name].empty?
          # e.send(name + "=", [])
      end

      # Update only if there's a difference. Note: this test prunes the associations hash
      if attr_difference.empty? && associations.empty?
        logger.tagged("SCRAPER", "#{log_note}", "IDENTICAL") {
          logger.info "Record contents identical. No updates to make."
        }
      else
        logger.tagged("SCRAPER", "#{log_note}", "UPDATE_RECORD") {
          logger.info "Update event -> #{attr_difference}; #{associations_hash.each { |a| 
          print a.size + " new " + a.key + "; "}} #{associations_hash}"
        }

        persisted_event.update!(attr_difference)
        associations_hash.each { |key, value| persisted_event.send(key) << value }
      end
    else
      logger.tagged("SCRAPER", "#{log_note}", "INVALID") {
        logger.info "Nothing written, validation errors for #{e.title}: #{e.errors.messages}"
      }
    end
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

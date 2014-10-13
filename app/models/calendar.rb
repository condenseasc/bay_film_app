require 'exceptions'

class Calendar < Document
  has_many :topics, inverse_of: :calendar, foreign_key: 'parent_id'
  has_many :images, as: :imageable
  validates :title, presence: true
  # belongs_to :summary
  # validates :summary, presence: true
  # validates_associated :summary

  # has_and_belongs_to_many :events, before_add: :check_for_duplicate_association
  # has_many :stills, inverse_of: :series
  # belongs_to :venue
  # validates :title, presence: true,
  #                   uniqueness: { scope: [:venue], message: 'exists in scope [:venue]' }

  def to_a
    [self]
  end


  def find_identical_scraped_record
    persisted_calendar = Calendar.where(title: title, scraped: true)

    if persisted_calendar.size == 1
      old_topics = persisted_calendar.first.topics

      if ((old_topics.to_a & topics.to_a) == topics.to_a)
        return persisted_calendar.first
      end
    elsif persisted_calendar.size > 1
      raise DuplicateRecordError.new, "Calendars #{p persisted_calendar.map(&:id)}"
    end unless !persisted_calendar
    nil
  end

  def all_events
    calendar_id = self.id
    # Event.joins('SELECT * FROM event INNER JOIN documents d ON (events.topic_id = d.id AND d.parent_id = ?)', calendar_id)
    # Event.find_by_sql('SELECT * FROM events INNER JOIN documents d ON (events.topic_id = d.id AND d.parent_id = ?)', 2)
    # Event.joins('INNER JOIN documents d ON (events.topic_id = d.id AND d.parent_id = ?)', 2)

    # Event.joins('INNER JOIN documents d WHERE events.topic_id = d.id').
    Event.joins(:topic).
      where('"documents"."parent_id" = ?', calendar_id).
      # where( topic: {calendar: self} ).
      order('time ASC')
      # references(:documents)
    # Event.joins('INNER JOIN documents d ON (events.topic_id = d.id)').where('d.parent_id = ?', 2)
  end

  def upcoming_events
    calendar_id = self.id
    Event.joins(:topic).
    # Event.joins('INNER JOIN documents d WHERE events.topic_id = d.id').
      where('"documents"."parent_id" = ? AND "events"."time" >= ?', calendar_id, Time.zone.now).
      order('time ASC')
  end

  # def check_for_duplicate_association(event)
  #   self.events.each do |e|
  #     if e.id === event.id
  #       raise ValidationError.new, "event already in series"
  #     end
  #   end
  # end

  # def self.associated_events_difference(existing_series, revised_series)
  #   existing_events = existing_series.events.map(&:id)
  #   revised_events = revised_series.events.map(&:id)
  #   revised_events.delete_if do |r|
  #     existing_events.any? { |e| e === r }
  #   end
  # end
end

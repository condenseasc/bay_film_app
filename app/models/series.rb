require 'exceptions'

class Series < ActiveRecord::Base
  has_and_belongs_to_many :events, before_add: :check_for_duplicate_association
  has_many :stills, inverse_of: :series
  belongs_to :venue

  validates :title, presence: true,
                    uniqueness: { scope: [:venue], message: 'exists in scope [:venue]' }

  def check_for_duplicate_association(event)
    self.events.each do |e|
      if e.id === event.id
        raise ValidationError.new, "event already in series"
      end
    end
  end

  def self.associated_events_difference(existing_series, revised_series)
    existing_events = existing_series.events.map(&:id)
    revised_events = revised_series.events.map(&:id)
    revised_events.delete_if do |r|
      existing_events.any? { |e| e === r }
    end
  end
end
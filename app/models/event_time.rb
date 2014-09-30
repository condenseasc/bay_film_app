class EventTime < ActiveRecord::Base
  belongs_to :event, dependent: :destroy
  validate :start,  presence: true, 
                    uniqueness: { scope: [:event], 
                                  message: 'exists in scope [:event_id]' }
  validate :event, presence: true
end

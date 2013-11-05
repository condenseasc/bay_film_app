class Event < ActiveRecord::Base
# attr_accessible :title, :time, :description
belongs_to :venue

validates :title, presence: true
validates :time, presence: true

end

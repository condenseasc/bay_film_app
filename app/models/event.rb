class Event < ActiveRecord::Base
attr_accessible :title, :time, :description

validates :title, presence: true
validates :time, presence: true

end

class EventStation < ApplicationRecord
  belongs_to :event
  belongs_to :station
end

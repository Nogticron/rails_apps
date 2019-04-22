class Event < ApplicationRecord
  has_many :event_stations, dependent: :destroy
  has_many :stations, through: :event_stations
end

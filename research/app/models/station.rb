class Station < ApplicationRecord
  has_many :event_stations, dependent: :destroy
  has_many :events, through: :event_stations

  has_many :line_stations, dependent: :destroy
  has_many :lines, through: :lines_stations
end

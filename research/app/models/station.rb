class Station < ApplicationRecord
  has_many :line_stations, dependent: :destroy
  has_many :lines, through: :line_stations
end

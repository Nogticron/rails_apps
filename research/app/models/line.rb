class Line < ApplicationRecord
  has_many :line_stations, dependent: :destroy
  has_many :stations, through: :line_stations
end

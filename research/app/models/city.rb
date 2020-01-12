class City < ApplicationRecord
  has_many :stations
  belongs_to :area
end

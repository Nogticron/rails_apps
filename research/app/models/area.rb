class Area < ApplicationRecord
  has_many :weathers, dependent: :destroy
  has_many :cities, dependent: :destroy
end

class Weather < ApplicationRecord
  belongs_to :area, dependent: :destroy
end

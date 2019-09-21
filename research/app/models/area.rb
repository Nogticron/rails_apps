class Area < ApplicationRecord
  has_many :weather, dependent: :destroy
end

class Station < ApplicationRecord
  has_many :line_stations, dependent: :destroy
  has_many :lines, through: :line_stations

  belongs_to :city

  def transfer_time
    case rank
    when 10
      300
    when 9
      240
    when 7 || 8
      180
    when 6 || 5 || 4
      120
    when 3
      80
    else
      60
    end
  end
end

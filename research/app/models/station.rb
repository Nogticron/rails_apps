class Station < ApplicationRecord
  has_many :line_stations, dependent: :destroy
  has_many :lines, through: :line_stations

  belongs_to :city

  def transfer_time
    mag = 1

    if city.area.name == '八王子'
      puts ' 八王子エリアなので遅延を発生させました'
      mag = 3
    end

    case rank
    when 10
      300 * mag
    when 9
      240 * mag
    when 7 || 8
      180 * mag
    when 6 || 5 || 4
      120 * mag
    when 3
      80 * mag
    else
      60 * mag
    end
  end
end

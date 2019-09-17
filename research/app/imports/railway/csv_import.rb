class Railway::CsvImport
  def self.get
    # https://opendata-web.site/station/13/eki/
    puts '23区内の駅を取得します'
    CSV.read('app/imports/railway/csv_roseneki.csv', headers: true).each do |row|
      unless Station.exists?(name: row['station_name'])
        station = Station.new(name: row['station_name'])
        station.lon = row['station_lon']
        station.lat = row['station_lat']
        station.save!
      else
        station = Station.find_by!(name: row['station_name'])
      end

      unless Line.exists?(name: row['line_name'], corporation: row['c.company_name'])
        line = Line.new(name: row['line_name'], corporation: row['c.company_name'])
        line.save!
      else
        line = Line.find_by!(name: row['line_name'], corporation: row['c.company_name'])
      end

      unless LineStation.exists?(line: line, station: station)
        line_station = LineStation.new(line: line, station: station, line_name: line.name, station_name: station.name, number: row['order'])
        line_station.save!
      end
    end
    puts '23区内の駅を取得完了しました'
  end
end
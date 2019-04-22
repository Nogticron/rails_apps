require 'csv'

class CsvImport
  def self.get
    # https://opendata-web.site/station/13/eki/
    CSV.read('app/imports/csv_roseneki_13.csv', headers: true).each do |row|
      unless Station.exists?(name: row['station_name'])
        station = Station.new(name: row['station_name'])
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
  end
end
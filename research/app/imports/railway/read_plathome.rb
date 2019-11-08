class Railway::ReadPlathome
  def self.read
    puts '駅のホームの座標を読み込みます'
    CSV.read('app/imports/railway/eki_file.csv', headers: true).each do |row|
      line = translate(row['line'])
      station = LineStation.find_by(station_name: row['name'], line_name: line)

      if station
        lon = row['lon'].to_f / 3600
        lat = row['lat'].to_f / 3600
        station.update(home_lat: lat.to_s, home_lon: lon.to_s)
      else
        # puts "#{row['name']} #{row['line']}"
      end
    end
  end

  def self.translate(name)
    name = name.sub(%r{JR}, 'ＪＲ')
    case name
    when 'ＪＲ東海道本線'
      name = 'ＪＲ東海道本線(東京－熱海)'
    when 'ＪＲ南武線'
      name = 'ＪＲ南武線(川崎－立川)'
    when 'ＪＲ中央線・総武線各駅停車'
      name = 'ＪＲ中央・総武線各駅停車'
    when 'ＪＲ中央本線'
      name = 'ＪＲ中央本線(東京－塩尻)'
    when 'ＪＲ八高線'
      name = 'ＪＲ八高線(八王子－高麗川)'
    end
    name
  end
end
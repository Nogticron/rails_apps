class Railway::StationImport
  ADDRESS_URL = 'https://www.homemate-research-station.com/name/13/'

  @agent = Mechanize.new

  def self.get
    puts '駅を取得します'
    CSV.read('app/imports/railway/data/csv_roseneki.csv', headers: true).each do |row|
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
    puts '駅の取得が完了しました'

    get_address
  end

  def self.get_address
    puts '駅の住所を取得します'
    page = @agent.get(ADDRESS_URL)

    unique_check_array   = []
    on_page_station_list = page.search('ul.menu_toggle .menu_toggle_lst .row_2 li')

    on_page_station_list.each do |list|
      already_registered = Station.where.not(address: nil)
      percent = already_registered.length.to_f * 100 / 650
      print "\r Progress : #{percent.round(2)}%"

      station_name = list.text.gsub(/\n/, '').gsub(/\t/, '').gsub(%r{駅}, '')
      detail_path  = list.at('a').get_attribute('href')

      station = Station.find_by(name: station_name)

      if station.present? && unique_check_array.exclude?({ name: station_name, path: detail_path })
        # next if station.address.nil?

        begin
          detail_page  = @agent.get('https://www.homemate-research-station.com' + detail_path)
        rescue => exception
          puts "\n   #{station_name} #{exception}"
          next
        end

        address_info = detail_page.search('.mod_adress_head dd.data')[1].text
        address_info = address_info.sub(/〒\d*-\d*\n/, '').sub(/東京都/, '').tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z').strip!

        station.update(address: address_info)

        unique_check_array.push({ name: station_name, path: detail_path })
      end
    end

    puts '住所の取得が完了しました'
  end
end

class Railway::ScrapeStationCity
  URL = 'https://www.navitime.co.jp/category/0802001/13/'

  def self.get
    puts '駅と市区町村のリレーションを作成します'
    agent = Mechanize.new

    1.upto(33) do |i|
      url = URL + "?page=#{i}"
      page = agent.get(url)

      station_list = page.search('#spot_list li')
      station_list.each do |box|
        name = box.at('.spot_name').inner_text.gsub(/[\s　]/, '')
        name = name.sub(%r{\(東京都\)}, '').gsub(%r{\〔.+\〕}, '')
                    .gsub(%r{\(.+\)}, '').gsub(%r{\[.+\]}, '').gsub(%r{ヶ}, 'ケ')
        station_name = translate_station(name)

        address = box.at('.address_name').inner_text.gsub(/[\s　]/, '')
        address = address.gsub(%r{\[地図\]}, '').gsub(%r{東京都}, '')
        idx = address.index('区')
        idx = address.index('市') if idx.nil?
        idx = address.index('町') if idx.nil?
        idx = address.index('村') if idx.nil?
        address = address.slice!(0..idx)
        city_name = translate_city(address)

        station = Station.find_by(name: station_name)
        city = City.find_by(name: city_name)

        station.update(city_id: city.id)
      end
    end
  end

  def self.translate_station(name)
    case name
    when '東京ビッグサイト'
      '国際展示場正門'
    when '東京国際クルーズターミナル'
      '船の科学館'
    else
      name
    end
  end

  def self.translate_city(address)
    case address
    when '西多摩郡奥多摩町'
      '奥多摩町'
    when '西多摩郡瑞穂町'
      '瑞穂町'
    else
      address
    end
  end
end
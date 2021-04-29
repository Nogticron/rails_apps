class Railway::LinkStationCity

  def self.get
    puts '駅と市区町村のリレーションを作成します'
    stations = Station.all

    stations.each do |station|
      address = station.address unless station.address.nil?
      idx = address.index('区')
      idx = address.index('市') if idx.nil?
      idx = address.index('町') if idx.nil?
      idx = address.index('村') if idx.nil?
      address = address.slice!(0..idx)
      city_name = translate_city(address)

      city = City.find_by(name: city_name)

      begin
        station.update(city_id: city.id)
      rescue => exception
        puts "#{station.name} #{city_name}"
        next
      end
    end
  end

  def self.translate_station(name)
    case name
    when '東京ビッグサイト'
      '国際展示場正門'
    when '東京国際クルーズターミナル'
      '船の科学館'
    when '南町田グランベリーパーク'
      '南町田'
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
    when '秋津'
      '東村山市'
    else
      address
    end
  end
end

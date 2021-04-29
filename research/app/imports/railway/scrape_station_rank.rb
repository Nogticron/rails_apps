class Railway::ScrapeStationRank
  JR_TOP_URL = 'https://www.jreast.co.jp/passenger/index.html'
  JR_OTHER_URL = 'https://www.jreast.co.jp/passenger/2018_0X.html'
  TOEI_URL = 'https://www.kotsu.metro.tokyo.jp/subway/kanren/passengers.html'
  METRO_URL = 'https://www.tokyometro.jp/corporate/enterprise/passenger_rail/transportation/passengers/index.html'
  KEIO_URL = 'https://www.keio.co.jp/group/traffic/railroading/passengers/index.html'
  ODAKYU_URL = 'https://www.odakyu.jp/company/railroad/users/'
  TOKYU_URL = 'https://www.tokyu.co.jp/railway/data/passengers/'
  TOBU_URL = 'http://www.tobu.co.jp/corporation/rail/station_info/'
  KEISEI_URL = 'http://www.keisei.co.jp/keisei/tetudou/accessj/people_top.html'
  TOKYO_MONO_URL = 'http://www.tokyo-monorail.co.jp/company/profile.html'

  @agent = Mechanize.new

  def self.get
    Station.find_each do |station|
      station.update(passengers: 0, rank: nil)
    end

    puts 'JRの駅の規模データを取得します' #2018年
    get_jr_data(JR_TOP_URL)
    1.upto(9) do |i|
      url = JR_OTHER_URL.sub(%r{X}, i.to_s)
      get_jr_data(url)
    end

    puts '都営線の駅の規模データを取得します' #2018年度
    get_toei_data

    puts '京王線の駅の規模データを取得します' #2018年度
    get_keio_data

    puts '小田急線の駅の規模データを取得します' #2018年度
    get_odakyu_data

    puts '東急線の駅の規模データを取得します' #2018年度
    get_tokyu_data

    puts '東武線の駅の規模データを取得します' #2018年度
    get_tobu_data

    puts '西武線の駅の規模データを取得します' #2018年度
    get_seibu_data

    puts '京急線の駅の規模データを取得します' #2018年度
    get_keikyu_data

    puts '京成線の駅の規模データを取得します' #2018年度
    get_keisei_data

    puts 'ゆりかもめの駅の規模データを取得します' #2018年度
    get_yurikamome_data

    puts '東京モノレールの駅の規模データを取得します' #2018年度
    get_tokyo_mono_data

    puts '多摩モノレールの駅の規模データを取得します' #2018年度
    get_tama_mono_data

    puts 'りんかい線の駅の規模データを取得します' #2018年度
    get_rinkai_data

    puts '東京メトロの駅の規模データを取得します' #2018年度
    get_metro_data

    # データがない世田谷線と荒川線はダミーデータを入れる
    put_dummy_data
  end

  def self.put_dummy_data
    Station.find_each do |station|
      if station.passengers == 0
        station.update(passengers: 1000, rank: 0)
      end
    end
  end

  def self.get_jr_data(url)
    page = @agent.get(url)

    data = page.search('.passengerTable.fl tr')
    data.each do |list|
      if list.at('.stationName')
        name = list.at('.stationName').inner_text
        station = Station.find_by(name: name)

        if station
          passenger_data = list.search('td')
          if passenger_data.size == 4
            this_passengers = passenger_data[3].inner_text.sub(%r{,}, '').to_i
          else
            this_passengers = passenger_data[4].inner_text.sub(%r{,}, '').to_i
          end
          sum = station.passengers + this_passengers
          station.update(passengers: sum)
        end
      end
    end

    data = page.search('.passengerTable.fr tr')
    data.each do |list|
      if list.at('.stationName')
        name = list.at('.stationName').inner_text
        station = Station.find_by(name: name)

        if station
          passenger_data = list.search('td')
          if passenger_data.size == 4
            this_passengers = passenger_data[3].inner_text.sub(%r{,}, '').to_i
          else
            this_passengers = passenger_data[4].inner_text.sub(%r{,}, '').to_i
          end
          sum = station.passengers + this_passengers
          station.update(passengers: sum)
        end
      end
    end

    # 東京と上野は新幹線を追加
    tokyo_st = Station.find_by(name: '東京')
    ueno_st = Station.find_by(name: '上野')
    tokyo_st.update(passengers: tokyo_st.passengers + 79991)
    ueno_st.update(passengers: ueno_st.passengers + 12337)
  end

  def self.get_toei_data
    page = @agent.get(TOEI_URL)

    lines = page.search('table.t-border')
    lines.each do |line|
      data = line.search('tr')

      data.each do |list|
        if list.at('.t-l') || list.at('.t-1')
          name = list.at('.t-l') || list.at('.t-1')
          passengers = list.search('td.t-c')

          station = Station.find_by(name: name.inner_text)
          if station
            this_passengers = passengers[0].inner_text.sub(%r{,}, '').to_i + passengers[1].inner_text.sub(%r{,}, '').to_i
            sum = station.passengers + this_passengers
            station.update(passengers: sum)
          end
        end
      end
    end
  end

  def self.get_metro_data
    page = @agent.get(METRO_URL)
    tameike_sanno = 0

    data = page.search('table.dataTable tr')
    data.each_with_index do |row, i|
      next if i == 0 || i == 40
      break if i == 132

      list = row.search('td')
      if list
        this_passengers = list[3].inner_text.sub(%r{,}, '').to_i

        name = list[2].inner_text if list[2]
        case name
        when '国会議事堂前・溜池山王'
          name = '国会議事堂前'
          tameike_sanno = this_passengers
        when '明治神宮前〈原宿〉'
          name = '明治神宮前'
        when '二重橋前〈丸の内〉'
          name = '二重橋前'
        when '麴町'
          name = '麹町'
        end

        station = Station.find_by(name: name)
        if station
          sum = station.passengers + this_passengers
          station.update(passengers: sum)
        end
      end
    end

    # 追加修正
    station = Station.find_by(name: '溜池山王')
    sum = station.passengers + tameike_sanno
    station.update(passengers: sum)
  end

  def self.get_keio_data
    page = @agent.get(KEIO_URL)

    tables = page.search('table.tbl01')
    tables.each do |table|
      data = table.search('tr')

      data.each_with_index do |row, i|
        next if i == 0

        list = row.search('td')
        station = Station.find_by(name: list[0].inner_text.sub(%r{ヶ}, 'ケ'))
        if station
          this_passengers = list[1].inner_text.sub(%r{,}, '').to_i
          sum = station.passengers + this_passengers
          station.update(passengers: sum)
        end
      end
    end
  end

  def self.get_odakyu_data
    page = @agent.get(ODAKYU_URL)

    tables = page.search('table.table')
    tables.each do |table|
      data = table.search('tr')

      data.each_with_index do |row, i|
        next if i == 0

        list = row.search('td')
        name = row.at('th').inner_text.sub(%r{ヶ}, 'ケ')
        name = '小田急多摩センター' if name == '小田急多摩センタ－'

        station = Station.find_by(name: name)
        if station
          this_passengers = list[0].inner_text.sub(%r{,}, '').to_i
          sum = station.passengers + this_passengers
          station.update(passengers: sum)
        end
      end
    end
  end

  def self.get_tokyu_data
    page = @agent.get(TOKYU_URL)

    tables = page.search('table.mod-table')
    tables.each do |table|
      data = table.search('tr')

      data.each_with_index do |row, i|
        next if i == 0

        list = row.search('td')
        name = row.at('th').inner_text.sub(%r{ヶ}, 'ケ')
        station = Station.find_by(name: name)
        if station
          this_passengers = list[2].inner_text.sub(%r{,}, '').to_i
          sum = station.passengers + this_passengers
          station.update(passengers: sum)
        end
      end
    end
  end

  def self.get_tobu_data
    page = @agent.get(TOBU_URL)

    tables = page.search('table.table0101')
    skips = [3, 4, 5, 6, 7, 8, 9, 11]
    tables.each_with_index do |table, j|
      next if skips.include?(j)

      data = table.search('tr')
      data.each_with_index do |row, i|
        next if i <= 1

        list = row.search('td')
        name = row.at('th').inner_text.sub(%r{ヶ}, 'ケ')
        case name
        when 'とうきょうスカイツリー（旧・業平橋）'
          name = 'とうきょうスカイツリー'
        when '押上（スカイツリー前）'
          name = '押上'
        end

        station = Station.find_by(name: name)
        if station
          this_passengers = list[1].inner_text.sub(%r{,}, '').to_i
          sum = station.passengers + this_passengers
          station.update(passengers: sum)
        end
      end
    end
  end

  def self.get_seibu_data
    CSV.read('app/imports/railway/data/seibu_line.csv', headers: true).each do |row|
      station = Station.find_by(name: row['name'])
      if station
        this_passengers = row['passengers'].to_i
        sum = station.passengers + this_passengers
        station.update(passengers: sum)
      end
    end
  end

  def self.get_keikyu_data
    CSV.read('app/imports/railway/data/keikyu_line.csv', headers: true).each do |row|
      station = Station.find_by(name: row['name'])
      if station
        this_passengers = row['passengers'].to_i
        sum = station.passengers + this_passengers
        station.update(passengers: sum)
      end
    end
  end

  def self.get_keisei_data
    page = @agent.get(KEISEI_URL)

    data = page.search('table tr')

    data.each_with_index do |row, i|
      next if i <= 1

      list = row.search('td')
      name = row.at('td').inner_text.sub(%r{ヶ}, 'ケ').gsub(%r{[\s　]}, '')
      station = Station.find_by(name: name)
      if station
        this_passengers = list[3].inner_text.sub(%r{,}, '').to_i
        sum = station.passengers + this_passengers
        station.update(passengers: sum)
      end
    end
  end

  def self.get_yurikamome_data
    CSV.read('app/imports/railway/data/yurikamome.csv', headers: true).each do |row|
      station = Station.find_by(name: row['name'])
      if station
        this_passengers = row['passengers'].to_i
        sum = station.passengers + this_passengers
        station.update(passengers: sum)
      end
    end
  end

  def self.get_tokyo_mono_data
    page = @agent.get(TOKYO_MONO_URL)

    tables = page.search('table')
    tables.each do |table|
      next if table.get_attribute('summary') != '1日当り駅別乗降人員'

      data = table.search('tr')
      data.each_with_index do |row, i|
        next if i == 0

        list = row.search('td')
        name = list[0].inner_text
        station = Station.find_by(name: name)
        if station
          rank = list[1].inner_text.sub(%r{,}, '').sub(%r{人}, '').to_i
          station.update(rank: rank)
        end

        name = list[2].inner_text
        station = Station.find_by(name: name)
        if station
          this_passengers = list[3].inner_text.sub(%r{,}, '').sub(%r{人}, '').to_i
          sum = station.passengers + this_passengers
          station.update(passengers: sum)
        end
      end
    end
  end

  def self.get_tama_mono_data
    CSV.read('app/imports/railway/data/tama_monorail.csv', headers: true).each do |row|
      station = Station.find_by(name: row['name'])
      if station
        this_passengers = row['passengers'].to_i
        sum = station.passengers + this_passengers
        station.update(passengers: sum)
      end
    end
  end

  def self.get_rinkai_data
    CSV.read('app/imports/railway/data/rinkai_line.csv', headers: true).each do |row|
      station = Station.find_by(name: row['name'])
      if station
        this_passengers = row['passengers'].to_i
        sum = station.passengers + this_passengers
        station.update(passengers: sum)
      end
    end
  end
end
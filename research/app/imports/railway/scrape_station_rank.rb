class Railway::ScrapeStationRank
  JR_TOP_URL = 'https://www.jreast.co.jp/passenger/index.html'
  JR_OTHER_URL = 'https://www.jreast.co.jp/passenger/2018_0X.html'
  TOEI_URL = 'https://www.kotsu.metro.tokyo.jp/subway/kanren/passengers.html'
  METRO_URL = 'https://www.tokyometro.jp/corporate/enterprise/passenger_rail/transportation/passengers/index.html'
  KEIO_URL = 'https://www.keio.co.jp/group/traffic/railroading/passengers/index.html'
  ODAKYU_URL = 'https://www.odakyu.jp/company/railroad/users/'
  TOKYU_URL = 'https://www.tokyu.co.jp/railway/data/passengers/'
  TOBU_URL = 'http://www.tobu.co.jp/corporation/rail/station_info/'

  @agent = Mechanize.new

  def self.return_rank(num)
    if num > 500000
      10
    elsif num > 300000
      9
    elsif num > 200000
      8
    elsif num > 100000
      7
    elsif num > 80000
      6
    elsif num > 50000
      5
    elsif num > 30000
      4
    elsif num > 10000
      3
    elsif num > 5000
      2
    else
      1
    end
  end

  def self.get
    # puts '都営線の駅の規模データを取得します' #2018年度
    # get_toei_data

    # puts '京王線の駅の規模データを取得します' #2018年度
    # get_keio_data

    # puts '小田急線の駅の規模データを取得します' #2018年度
    # get_odakyu_data

    # puts '東急線の駅の規模データを取得します' #2018年度
    # get_tokyu_data

    # puts '東武線の駅の規模データを取得します' #2018年度
    # get_tobu_data

    puts '西武線の駅の規模データを取得します' #2018年度
    get_seibu_data

    # puts '東京メトロの駅の規模データを取得します' #2018年度
    # get_metro_data

    # puts 'JRの駅の規模データを取得します' #2018年
    # get_jr_data(JR_TOP_URL)
    # 1.upto(9) do |i|
    #   url = JR_OTHER_URL.sub(%r{X}, i.to_s)
    #   get_jr_data(url)
    # end
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
            passenger = passenger_data[3].inner_text.sub(%r{,}, '').to_i
          else
            passenger = passenger_data[4].inner_text.sub(%r{,}, '').to_i
          end
          station_rank = return_rank(passenger)
          station.update(rank: station_rank)
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
            passenger = passenger_data[3].inner_text.sub(%r{,}, '').to_i
          else
            passenger = passenger_data[4].inner_text.sub(%r{,}, '').to_i
          end
          station_rank = return_rank(passenger)
          station.update(rank: station_rank)
        end
      end
    end
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
          passenger_sum = passengers[0].inner_text.sub(%r{,}, '').to_i + passengers[1].inner_text.sub(%r{,}, '').to_i
          station_rank = return_rank(passenger_sum)

          station = Station.find_by(name: name.inner_text)
          station.update(rank: station_rank) if station
        end
      end
    end
  end

  def self.get_metro_data
    page = @agent.get(METRO_URL)

    data = page.search('table.dataTable tr')
    data.each_with_index do |row, i|
      next if i == 0 || i == 40
      break if i == 132

      list = row.search('td')
      if list
        name = list[2].inner_text if list[2]
        case name
        when '国会議事堂前・溜池山王'
          name = '国会議事堂前'
        when '明治神宮前〈原宿〉'
          name = '明治神宮前'
        when '二重橋前〈丸の内〉'
          name = '二重橋前'
        end

        station_rank = return_rank(list[3].inner_text.sub(%r{,}, '').to_i)
        station = Station.find_by(name: name)
        if station
          station.update(rank: station_rank)
        end
      end
    end

    # 追加修正
    station = Station.find_by(name: '溜池山王')
    rank = Station.find_by(name: '国会議事堂前').rank
    station.update(rank: rank)
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
          rank = return_rank(list[1].inner_text.sub(%r{,}, '').to_i)
          station.update(rank: rank)
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
        station = Station.find_by(name: name)
        if station
          rank = return_rank(list[0].inner_text.sub(%r{,}, '').to_i)
          station.update(rank: rank)
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
          rank = return_rank(list[2].inner_text.sub(%r{,}, '').to_i)
          station.update(rank: rank)
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
          rank = return_rank(list[1].inner_text.sub(%r{,}, '').to_i)
          station.update(rank: rank)
        end
      end
    end
  end

  def self.get_seibu_data
    CSV.read('app/imports/railway/data/seibu_line.csv', headers: true).each do |row|
      station = Station.find_by(name: row['name'])
      if station
        rank = return_rank(row['passengers'].to_i)
        station.update(rank: rank)
      end
    end
  end
end
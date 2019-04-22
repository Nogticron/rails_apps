class ScrapeStations

  @agent = Mechanize.new

  def self.get
    puts '23区内の駅を取得します'
    url = 'https://www.navitime.co.jp/category/0802001/13/'
    get_lines_area(url)
    puts '23区内の駅を取得完了しました'
  end

  def self.get_lines_area(url)
    page = @agent.get(url)
    areas = page.search('.area_list li')
    links = []
    areas.each do |area|
      if area.inner_text.include?('区')
        links << area.at('a').get_attribute('href')
      end
    end

    get_stations(links)
  end

  def self.get_stations(links)
    links.each do |link|
      page = @agent.get(link)
      area_name = page.at('#page_title').inner_text.gsub(/東京都/, '').gsub(/の駅一覧/, '').gsub(%r{\n}, '').gsub(%r{\t}, '')
      stations_box = page.search('#spot_list li .spot_name')

      stations_box.each do |station|
        station = station.inner_text.gsub(%r{\n}, '').gsub(%r{\t}, '')
        station = station.gsub(/ヶ/, 'ケ')
        station = station.gsub(/早稲田〔東西線〕/, '早稲田(東京メトロ)') #早稲田
        station = station.gsub(/浅草\(つくばエクスプレス\)/, '浅草') #浅草
        station = station.gsub(/押上\[スカイツリー前\]/, '押上') #押上
        station = station.gsub(/両国〔JR〕/, '両国').gsub(/両国〔大江戸線〕/, '両国') #両国
        station = station.gsub(/とうきょうスカイツリー\[業平橋\]/, 'とうきょうスカイツリー') #とうきょうスカイツリー
        station = station.gsub(/国際展示場\(りんかい線\)/, '国際展示場') #国際展示場
        station = station.gsub(/東京ビッグサイト\(ゆりかもめ\)/, '東京ビッグサイト') #東京ビッグサイト
        station = station.gsub(/天王洲アイル\(りんかい線\)/, '天王洲アイル') #天王洲アイル
        station = station.gsub(/自由が丘\(東京都\)/, '自由が丘') #自由が丘
        station = station.gsub(/羽田空港第1ビル\(モノレール\)/, '羽田空港第１ビル(東京モノレール・ＪＡＬ利用)') 
        station = station.gsub(/羽田空港第2ビル\(モノレール\)/, '羽田空港第２ビル(東京モノレール・ＡＮＡ利用)') 
        station = station.gsub(/羽田空港国際線ビル\(モノレール\)/, '羽田空港国際線ビル(東京モノレール)')
        station = station.gsub(/恵比寿\(東京都\)/, '恵比寿') #恵比寿
        station = station.gsub(/恵比寿駅前/, '恵比寿') #恵比寿
        station = station.gsub(/町屋〔千代田線〕/, '町屋(東京メトロ)') #町屋(東京メトロ)
        station = station.gsub(/南千住\(常磐線\)/, '南千住')
        station = station.gsub(/南千住〔日比谷線〕/, '南千住')
        station = station.gsub(/町屋〔京成線〕/, '町屋(京成線)')
        station = station.gsub(/南千住〔つくばエクスプレス〕/, '南千住')
        station = station.gsub(/豊島園〔西武線〕/, '豊島園').gsub(/豊島園〔大江戸線〕/, '豊島園')

        unless Station.exists?(name: station)
          create = Station.new(name: station, area: area_name)
          create.save!
        end
      end
    end
  end

end
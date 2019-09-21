class Weather::ImportWeatherData
  # 2018年4月15日から2018年9月1日まで

  def self.get
    read('tokyo')
    read('edogawa')
    read('hachioji')
    read('haneda')
    read('nerima')
    read('setagaya')
    read('fuchu')
  end

  # [品質情報]　8: データ欠損なし

  # weather_state
  # 1	快晴
  # 2	晴れ
  # 3	薄曇
  # 4	曇
  # 5	煙霧
  # 6	砂じん嵐
  # 7	地ふぶき
  # 8	霧
  # 9	霧雨
  # 10	雨
  # 11	みぞれ
  # 12	雪
  # 13	あられ
  # 14	ひょう
  # 15	雷
  # 16	しゅう雨または止み間のある雨
  # 17	着氷性の雨
  # 18	着氷性の霧雨
  # 19	しゅう雪または止み間のある雪
  # 22	霧雪
  # 23	凍雨
  # 24	細氷
  # 28	もや
  # 101	降水またはしゅう雨性の降水

  def self.read(area_name)
    area = Area.find_by(e_name: area_name)
    puts "#{area.name}エリアの天気情報を取得します"

    CSV.read("app/imports/weather/weather_#{area_name}.csv", headers: true).each do |row|
      date = Date.strptime(row['年月日'], '%Y/%m/%d')
      time = Time.strptime(row['時間'], '%H:%M:00')
      next if Weather.find_by(date: row['年月日'], time: row['時間'])

      weather = area.weather.new
      weather.date = date
      weather.time = time
      weather.temperture = row['気温(℃)']
      weather.temp_quality = row['気温(℃)品質情報']
      weather.precipitation = row['降水量(mm)']
      weather.is_occurrence = row['降水量(mm)現象なし情報']
      weather.precip_quality = row['降水量(mm)品質情報']
      weather.weather_state = row['天気']
      weather.weather_quality = row['天気(品質情報)']
      weather.save!
    end
  end

end
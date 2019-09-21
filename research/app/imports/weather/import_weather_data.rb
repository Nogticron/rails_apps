class Weather::ImportWeatherData
  # 2018年4月15日から2018年9月1日まで

  def self.get
    read('weather_tokyo.csv')
    # read('weather_edogawa.csv')
    # read('weather_hachioji.csv')
    # read('weather_haneda.csv')
    # read('weather_nerima.csv')
    # read('weather_setagaya.csv')
    # read('weather_fuchu.csv')
  end

  def self.read(file_name)
    CSV.read("app/imports/weather/#{file_name}", headers: true).each_with_index do |row, i|
      break if i > 5

      p i
      p row

      
    end
  end

end
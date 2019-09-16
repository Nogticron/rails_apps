class ScrapeWeather

  @agent = Mechanize.new

  def self.get
    puts '天気の過去データを取得します'
    (Date.parse('2000-01-01')..Date.parse('2000-12-31')).each do |date|
      month =
        if date.month < 10
          '0' + date.month.to_s
        else
          date.month.to_s
        end

      day =
        if date.day < 10
          '0' + date.day.to_s
        else
          date.day.to_s
        end

      url = 'https://weather.goo.ne.jp/past/662/0000' + month + day
      
      page = @agent.get(url)

      days = page.search('table.temppast tr')
      days.each_with_index do |day , i|
        next if i == 0

        row = day.search('td')
        date_str = row[0].inner_text.gsub(%r{（.）}, '')
        date = Date.strptime(date_str, '%Y年%m月%d日')
        if Weather.exists?(date: date)
          next
        else
          max = row[1].inner_text.to_f
          min = row[2].inner_text.to_f
          if row[3].at('img')
            we_9 = row[3].at('img').get_attribute('alt')
          else
            we_9 = row[3].inner_text
          end

          if row[4].at('img')
            we_12 = row[4].at('img').get_attribute('alt')
          else
            we_12 = row[4].inner_text
          end

          if row[5].at('img')
            we_15 = row[5].at('img').get_attribute('alt')
          else
            we_15 = row[5].inner_text
          end
          
          amount = row[6].inner_text

          weather = Weather.new
          weather.date = date
          weather.max_temp = max
          weather.min_temp = min
          weather.weather_9 = we_9
          weather.weather_12 = we_12
          weather.weather_15 = we_15
          weather.amount = amount
          weather.save!
        end
      end
    end
  end
end
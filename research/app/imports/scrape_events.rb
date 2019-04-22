require "time"
class ScrapeEvents

  @agent = Mechanize.new

  def self.get
    puts '東京ドームのイベントを取得します'
    url = 'https://baseball-freak.com/audience/giants.html'
    scrape(url, 19)
    9.upto(18) do |y_num|
      y_num = '0' + y_num.to_s if y_num < 10
      url = 'https://baseball-freak.com/audience/' + y_num.to_s + '/giants.html'
      scrape(url, y_num)
    end
  end

  def self.scrape(url, y_num)
    page = @agent.get(url)

    unless url == 'https://baseball-freak.com/audience/giants.html'
      year = page.at('head title').inner_text.gsub(%r{読売ジャイアンツの観客動員数\(}, '').gsub(%r{年\) | プロ野球Freak}, '').gsub(%r{\|}, '')
    else
      y_num = '0' + y_num.to_s if y_num < 10
      year = '20' + y_num.to_s
    end
    year = Date.strptime(year, '%Y')

    box = page.search('.tschedule tr')
    box.each_with_index do |row, i|
      next if i == 0

      row = row.search('td')
      next if row[1].inner_text == " "
      next unless row[7].inner_text == '東京ドーム' 

      date_str = row[0].inner_text.gsub(%r{\(.\)}, '')
      date = Date.strptime(date_str, '%m月%d日')
      date = date.change(year: year.year)
      name = row[3].inner_text
      if Event.exists?(date: date, name: name)
        event = Event.find_by(date: date, name: name)
      else
        event = Event.new
        event.date = date
        event.result = row[1].inner_text
        event.name = name
        event.audience = row[5].inner_text.gsub(/,/, '').gsub(/ 人/, '').to_i
        unless date.wday == 0
          time = Time.parse("#{year}-#{date.month}-#{date.day} " + '18:00:00 +0000')
        else
          time = Time.parse("#{year}-#{date.month}-#{date.day} " + '14:00:00 +0000')
        end
        event.start_time = time
        end_time = Time.parse("0#{row[6].inner_text}:00")
        end_time = time + (end_time.hour * 60 * 60) + (end_time.min * 60) 
        event.end_time = end_time
        
        event.save!
      end
      set_relation(event)

      y_num_s =
        if y_num.to_i < 10
          '0' + y_num.to_s
        else
          y_num.to_s
        end
      url = 'https://baseball-freak.com/audience/' + y_num_s + '/giants.html'
    end
  end

  def self.set_relation(event)
    station = Station.find_by(name: '水道橋')
    unless EventStation.exists?(station: station, event: event)
      EventStation.new(station: station, event: event).save
    end
    station = Station.find_by(name: '春日')
    unless EventStation.exists?(station: station, event: event)
      EventStation.new(station: station, event: event).save
    end
    station = Station.find_by(name: '後楽園')
    unless EventStation.exists?(station: station, event: event)
      EventStation.new(station: station, event: event).save
    end
  end

end
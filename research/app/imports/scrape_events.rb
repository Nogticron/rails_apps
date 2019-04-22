require "time"
class ScrapeEvents

  @agent = Mechanize.new

  def self.get
    puts '東京ドームのイベントを取得します'
    page = @agent.get('https://baseball-freak.com/audience/giants.html')

    box = page.search('.tschedule tr')
    box.each_with_index do |row, i|
      next if i == 0

      row = row.search('td')
      next if row[1].inner_text == " "
      next unless row[7].inner_text == '東京ドーム' 

      date_str = row[0].inner_text
      date = Date.strptime(date_str, '%m月%d日')
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
          time = Time.parse("#{date.year}-#{date.month}-#{date.day} " + '18:00:00 +0000')
        else
          time = Time.parse("#{date.year}-#{date.month}-#{date.day} " + '14:00:00 +0000')
        end
        event.start_time = time
        end_time = Time.parse("0#{row[6].inner_text}:00")
        end_time = time + (end_time.hour * 60 * 60) + (end_time.min * 60) 
        event.end_time = end_time
        
        event.save!
      end

      set_relation(event)
    end
  end

  def self.set_relation(event)
    station = Station.find_by(name: '水道橋')
    EventStation.new(station: station, event: event).save
    station = Station.find_by(name: '春日')
    EventStation.new(station: station, event: event).save
    station = Station.find_by(name: '後楽園')
    EventStation.new(station: station, event: event).save
  end

end
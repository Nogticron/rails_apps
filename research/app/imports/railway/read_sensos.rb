class Railway::ReadSensos

  def self.convert_station(name)
    name = name.gsub(%r{\d+}, '').sub(%r{\(}, '').sub(%r{\)}, '').gsub(%r{:}, '')
  end

  def self.convert_time(time)
    if time.size == 3
      time.insert(1, ':')
    elsif time.size == 4
      time.insert(2, ':')
    else
      '00:00'
    end
  end

  def self.start
    puts '大都市交通センサスを読み込みます'
    read

    puts '大都市交通センサスの駅を読み込みます'
    set_ids

    puts
  end

  def self.read
    CSV.read('app/imports/railway/data/H17_utf-8.csv', headers: true).each do |row|
      print "\r Progress : #{row['レコード番号']} /140238"
      next if Person.find_by(record_id: row['レコード番号'])

      person = Person.new
      person.record_id = row['レコード番号']
      person.age = row['年齢']
      person.passport = row['定期券保有']
      person.magnification = row['拡大率']
      person.am_departure_time1 = convert_time(row['経路1-乗車時刻'])
      person.am_arriving_time = convert_time(row['経路1-降車時刻'])

      person.am_st1 = convert_station(row['経路1-乗車駅1'])
      person.am_st2 = convert_station(row['経路1-乗車駅2'])
      person.am_st3 = convert_station(row['経路1-乗車駅3'])
      person.am_st4 = convert_station(row['経路1-乗車駅4'])
      person.am_st5 = convert_station(row['経路1-乗車駅5'])
      person.am_st6 = convert_station(row['経路1-乗車駅6'])
      person.am_st7 = convert_station(row['経路1-乗車駅7'])
      person.am_st8 = convert_station(row['経路1-乗車駅8'])
      # 終着駅の時間を到着時間にする
      set_goal_time(person)
      person.save!
    end
    puts "\n大都市交通センサスを読み込みました"
  end

  def self.set_goal_time(person)
    if person.am_st3 == ''
      person.am_arrival_time2 = person.am_arriving_time
    elsif person.am_st4 == ''
      person.am_arrival_time3 = person.am_arriving_time
    elsif person.am_st5 == ''
      person.am_arrival_time4 = person.am_arriving_time
    elsif person.am_st6 == ''
      person.am_arrival_time5 = person.am_arriving_time
    elsif person.am_st7 == ''
      person.am_arrival_time6 = person.am_arriving_time
    elsif person.am_st8 == ''
      person.am_arrival_time7 = person.am_arriving_time
    else
      person.am_arrival_time8 = person.am_arriving_time
    end
  end

  def self.set_ids
    size = Person.all.size
    Person.find_each.with_index(1) do |person, i|
      print "\r Progress : #{i} /#{size}"
      station = Station.find_by(name: person.am_st1)
      person.update(st1_id: station.id) if station

      station = Station.find_by(name: person.am_st2)
      person.update(st2_id: station.id) if station

      station = Station.find_by(name: person.am_st3)
      person.update(st3_id: station.id) if station

      station = Station.find_by(name: person.am_st4)
      person.update(st4_id: station.id) if station

      station = Station.find_by(name: person.am_st5)
      person.update(st5_id: station.id) if station

      station = Station.find_by(name: person.am_st6)
      person.update(st6_id: station.id) if station

      station = Station.find_by(name: person.am_st7)
      person.update(st7_id: station.id) if station

      station = Station.find_by(name: person.am_st8)
      person.update(st8_id: station.id) if station
    end
  end
end
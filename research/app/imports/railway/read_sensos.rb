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
      person.s_time = convert_time(row['経路1-乗車時刻'])
      person.s_arriving_time = convert_time(row['経路1-降車時刻'])

      person.r1_st1 = convert_station(row['経路1-乗車駅1'])
      person.r1_st2 = convert_station(row['経路1-乗車駅2'])
      person.r1_st3 = convert_station(row['経路1-乗車駅3'])
      person.r1_st4 = convert_station(row['経路1-乗車駅4'])
      person.r1_st5 = convert_station(row['経路1-乗車駅5'])
      person.r1_st6 = convert_station(row['経路1-乗車駅6'])
      person.r1_st7 = convert_station(row['経路1-乗車駅7'])
      person.r1_st8 = convert_station(row['経路1-乗車駅8'])
      # 終着駅の時間を到着時間にする
      set_goal_time(person)
      person.save!
    end
    puts "\n大都市交通センサスを読み込みました"
  end

  def self.set_goal_time(person)
    if person.r1_st3 == ''
      person.r1_time2 = person.s_arriving_time
    elsif person.r1_st4 == ''
      person.r1_time3 = person.s_arriving_time
    elsif person.r1_st5 == ''
      person.r1_time4 = person.s_arriving_time
    elsif person.r1_st6 == ''
      person.r1_time5 = person.s_arriving_time
    elsif person.r1_st7 == ''
      person.r1_time6 = person.s_arriving_time
    elsif person.r1_st8 == ''
      person.r1_time7 = person.s_arriving_time
    else
      person.r1_time8 = person.s_arriving_time
    end
  end
end
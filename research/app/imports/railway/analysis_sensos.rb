class Railway::AnalysisSensos
  def self.start
    puts "駅在留時間を計算します"
    read_between_time_data
    set_between_time

    puts "\n駅間移動データを作成します"
    link_stations

    puts "\n駅ごとの人数を集計します"
    aggregate_people
  end

  def self.set_between_time
    i = 0
    size = Person.all.count
    Person.find_each do |person|
      print "\r Progress : #{i += 1} /#{size}"
      via_station_num =
        if person.r1_st3 == ''
          0
        elsif person.r1_st4 == ''
          1
        elsif person.r1_st5 == ''
          2
        elsif person.r1_st6 == ''
          3
        elsif person.r1_st7 == ''
          4
        elsif person.r1_st8 == ''
          5
        else
          6
        end

      next if !person.s_arriving_time || !person.s_time || !via_station_num

      ride_time = person.s_arriving_time - person.s_time
      between_time = ride_time / (via_station_num + 1)

      update_via_station_time(person, via_station_num, between_time)
    end
  end

  def self.link_stations
    i = 0
    size = Person.all.count
    Person.find_each do |person|
      print "\r Progress : #{i += 1} /#{size}"
      station = Station.find_by(name: person.r1_st1)
      person.update(st1_id: station.id) if station

      station = Station.find_by(name: person.r1_st2)
      person.update(st2_id: station.id) if station

      next if person.r1_st3 == ''
      station = Station.find_by(name: person.r1_st3)
      person.update(st3_id: station.id) if station

      next if !person.r1_st4 = ''
      station = Station.find_by(name: person.r1_st4)
      person.update(st4_id: station.id) if station

      next if !person.r1_st5 = ''
      station = Station.find_by(name: person.r1_st5)
      person.update(st5_id: station.id) if station

      next if !person.r1_st6 = ''
      station = Station.find_by(name: person.r1_st6)
      person.update(st6_id: station.id) if station

      next if !person.r1_st7 = ''
      station = Station.find_by(name: person.r1_st7)
      person.update(st7_id: station.id) if station

      next if !person.r1_st8 = ''
      station = Station.find_by(name: person.r1_st8)
      person.update(st8_id: station.id) if station
    end
  end

  def self.aggregate_people
    times = ['00:00:00', '06:00:00', '06:20:00', '06:40:00', '07:00:00', '07:20:00', '07:40:00',
               '08:00:00', '08:20:00', '08:40:00', '09:00:00', '09:20:00',
               '09:40:00', '10:00:00', '10:20:00', '10:40:00', '11:00:00', '23:59:00']

    size = Station.all.count
    j = 0
    Station.all.each do |station|
      print "\r Progress : #{j += 1} /#{size}"
      times.each_with_index do |time, i|
        break if time == '23:59:00'

        sum = 0
        if Person.where(st1_id: station.id, s_time: time..times[i+1])
          people = Person.where(st1_id: station.id, s_time: time..times[i+1])
          people.each do |p|
            sum += p.magnification
          end
        end

        if Person.where(st2_id: station.id, r1_time2: time..times[i+1])
          people = Person.where(st2_id: station.id, r1_time2: time..times[i+1])
          people.each do |p|
            sum += p.magnification
          end
        end

        if Person.where(st3_id: station.id, r1_time3: time..times[i+1])
          people = Person.where(st3_id: station.id, r1_time3: time..times[i+1])
          people.each do |p|
            sum += p.magnification
          end
        end

        if Person.where(st4_id: station.id, r1_time4: time..times[i+1])
          people = Person.where(st4_id: station.id, r1_time4: time..times[i+1])
          people.each do |p|
            sum += p.magnification
          end
        end

        if Person.where(st5_id: station.id, r1_time5: time..times[i+1])
          people = Person.where(st5_id: station.id, r1_time5: time..times[i+1])
          people.each do |p|
            sum += p.magnification
          end
        end

        if Person.where(st6_id: station.id, r1_time6: time..times[i+1])
          people = Person.where(st6_id: station.id, r1_time6: time..times[i+1])
          people.each do |p|
            sum += p.magnification
          end
        end

        if Person.where(st7_id: station.id, r1_time7: time..times[i+1])
          people = Person.where(st7_id: station.id, r1_time7: time..times[i+1])
          people.each do |p|
            sum += p.magnification
          end
        end

        if Person.where(st8_id: station.id, r1_time8: time..times[i+1])
          people = Person.where(st8_id: station.id, r1_time8: time..times[i+1])
          people.each do |p|
            sum += p.magnification
          end
        end

        input_time_to_station(station, sum, i)
      end
    end
  end

  def self.input_time_to_station(station, sum, i)
    case i
    when 0
      station.before_0600 = sum
    when 1
      station.between_0600_0620 = sum
    when 2
      station.between_0620_0640 = sum
    when 3
      station.between_0640_0700 = sum
    when 4
      station.between_0700_0720 = sum
    when 5
      station.between_0720_0740 = sum
    when 6
      station.between_0740_0800 = sum
    when 7
      station.between_0800_0820 = sum
    when 8
      station.between_0820_0840 = sum
    when 9
      station.between_0840_0900 = sum
    when 10
      station.between_0900_0920 = sum
    when 11
      station.between_0920_0940 = sum
    when 12
      station.between_0940_1000 = sum
    when 13
      station.between_1000_1020 = sum
    when 14
      station.between_1020_1040 = sum
    when 15
      station.between_1040_1100 = sum
    when 16
      station.after_1100 = sum
    end
    station.save!
  end

  def self.update_via_station_time(person, via_station_num, between_time)
    if via_station_num >= 0
      person.update(r1_time2: person.s_time + between_time)
    end

    if via_station_num >= 1
      person.update(r1_time3: person.r1_time2 + between_time)
    end

    if via_station_num >= 2
      person.r1_time3 + between_time
      person.update(r1_time4: person.r1_time3 + between_time)
    end

    if via_station_num >= 3
      person.update(r1_time5: person.r1_time4 + between_time)
    end

    if via_station_num >= 4
      person.update(r1_time6: person.r1_time5 + between_time)
    end

    if via_station_num >= 5
      person.update(r1_time7: person.r1_time6 + between_time)
    end

    if via_station_num >= 6
      person.update(r1_time8: person.r1_time7 + between_time)
    end
  end

end
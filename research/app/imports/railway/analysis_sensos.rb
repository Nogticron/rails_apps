class Railway::AnalysisSensos
  @station_list = []
  @between_time = []

  def self.start
    puts "駅間時間を読み込みます"
    read_between_time_data

    puts "\n駅在留時間を計算します"
    set_between_time

    puts "\n駅間移動データを作成します"
    # link_stations

    puts "\n駅ごとの人数を集計します"
    # aggregate_people
  end

  def self.read_between_time_data
    puts ' 駅を読取中'
    CSV.read('app/imports/railway/data/between_time.csv', headers: false).each_with_index do |row, i|
      next if i < 1

      set = {id: row[0], name: row[2]}
      @station_list << set
    end

    ids = @station_list.pluck(:id)

    puts " 駅間時間を読取中"
    CSV.read('app/imports/railway/data/between_time.csv', headers: true).each_with_index do |row, i|
      print "\r  Progress : #{i+1} /2009"

      line = []
      ids.each do |id|
        line << row["#{id}"]
      end

      @between_time << line
    end
  end

  def self.set_between_time
    i = 0
    size = Person.all.count
    Person.find_each do |person|
      print "\r Progress : #{i += 1} /#{size}"

      via_station_num = # 経由駅の数
        if person.am_st3 == ''
          0
        elsif person.am_st4 == ''
          1
        elsif person.am_st5 == ''
          2
        elsif person.am_st6 == ''
          3
        elsif person.am_st7 == ''
          4
        elsif person.am_st8 == ''
          5
        else
          6
        end

      next if !person.am_arriving_time || !person.am_departure_time1 || !via_station_num

      default_set_via_station_time(person, via_station_num)
      update_via_station_time(person, via_station_num)
    end
  end

  def self.update_via_station_time(person, via_station_num)
    # 駅に到着した時間を設定する(都外は120秒前統一)
    if person.st1_id
      stay_time = Station.find(person.st1_id).transfer_time
      person.update(am_arrival_time1: person.am_departure_time1 - stay_time)
    else
      person.update(am_arrival_time1: person.am_departure_time1 - 120)
    end

    # am_st1出発からam_st2到着までの時間を設定する
    start_st_idx = @station_list.pluck(:name).index(person.am_st1)
    goal_st_idx = @station_list.pluck(:name).index(person.am_st2)
    if start_st_idx && goal_st_idx
      ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
      person.am_arrival_time2 = person.am_departure_time1 + ride_time
    end

    # am_st2滞留の時間を設定する
    if person.st2_id
      stay_time = Station.find(person.st2_id).transfer_time
      person.update(am_departure_time2: person.am_arrival_time2 + stay_time)
    else
      person.update(am_departure_time2: person.am_arrival_time2 + 120)
    end

    # am_st2出発からam_st3到着までの時間を設定する
    if via_station_num > 0
      start_st_idx = @station_list.pluck(:name).index(person.am_st2)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st3)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time3 = person.am_departure_time2 + ride_time
      end
    end

    # am_st3滞留の時間を設定する
    if person.st3_id
      stay_time = Station.find(person.st3_id).transfer_time
      person.update(am_departure_time3: person.am_arrival_time3 + stay_time)
    else
      person.update(am_departure_time3: person.am_arrival_time3 + 120)
    end

    # am_st3出発からam_st4到着までの時間を設定する
      start_st_idx = @station_list.pluck(:name).index(person.am_st3)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st4)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time4 = person.am_departure_time3 + ride_time
      end
    end

    # am_st4滞留の時間を設定する
    if person.st4_id
      stay_time = Station.find(person.st4_id).transfer_time
      person.update(am_departure_time4: person.am_arrival_time4 + stay_time)
    else
      person.update(am_departure_time4: person.am_arrival_time4 + 120)
    end

    # am_st4出発からam_st5到着までの時間を設定する
    if via_station_num > 2
      start_st_idx = @station_list.pluck(:name).index(person.am_st4)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st5)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time5 = person.am_departure_time4 + ride_time
      end
    end

    # am_st5滞留の時間を設定する
    if person.st5_id
      stay_time = Station.find(person.st5_id).transfer_time
      person.update(am_departure_time5: person.am_arrival_time5 + stay_time)
    else
      person.update(am_departure_time5: person.am_arrival_time5 + 120)
    end

    # am_st5出発からam_st6到着までの時間を設定する
    if via_station_num > 3
      start_st_idx = @station_list.pluck(:name).index(person.am_st5)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st6)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time6 = person.am_departure_time5 + ride_time
      end
    end

    # am_st6滞留の時間を設定する
    if person.st6_id
      stay_time = Station.find(person.st6_id).transfer_time
      person.update(am_departure_time6: person.am_arrival_time6 + stay_time)
    else
      person.update(am_departure_time6: person.am_arrival_time6 + 120)
    end

    # am_st6出発からam_st7到着までの時間を設定する
    if via_station_num > 4
      start_st_idx = @station_list.pluck(:name).index(person.am_st6)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st7)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time7 = person.am_departure_time6 + ride_time
      end
    end

    # am_st7滞留の時間を設定する
    if person.st7_id
      stay_time = Station.find(person.st7_id).transfer_time
      person.update(am_departure_time7: person.am_arrival_time7 + stay_time)
    else
      person.update(am_departure_time7: person.am_arrival_time7 + 120)
    end

    # am_st7出発からam_st8到着までの時間を設定する
    if via_station_num > 5
      start_st_idx = @station_list.pluck(:name).index(person.am_st7)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st8)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time8 = person.am_departure_time7 + ride_time
      end
    end

    # am_st8をでた時間を設定する
    if person.st8_id
      stay_time = Station.find(person.st8_id).transfer_time
      person.update(am_departure_time8: person.am_arrival_time8 + stay_time)
    else
      person.update(am_departure_time8: person.am_arrival_time8 + 120)
    end

    person.save!
  end

  def self.link_stations
    i = 0
    size = Person.all.count
    Person.find_each do |person|
      print "\r Progress : #{i += 1} /#{size}"
      station = Station.find_by(name: person.am_st1)
      person.update(st1_id: station.id) if station

      station = Station.find_by(name: person.am_st2)
      person.update(st2_id: station.id) if station

      next if person.am_st3 == ''
      station = Station.find_by(name: person.am_st3)
      person.update(st3_id: station.id) if station

      next if !person.am_st4 = ''
      station = Station.find_by(name: person.am_st4)
      person.update(st4_id: station.id) if station

      next if !person.am_st5 = ''
      station = Station.find_by(name: person.am_st5)
      person.update(st5_id: station.id) if station

      next if !person.am_st6 = ''
      station = Station.find_by(name: person.am_st6)
      person.update(st6_id: station.id) if station

      next if !person.am_st7 = ''
      station = Station.find_by(name: person.am_st7)
      person.update(st7_id: station.id) if station

      next if !person.am_st8 = ''
      station = Station.find_by(name: person.am_st8)
      person.update(st8_id: station.id) if station
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

  def self.default_set_via_station_time(person, via_station_num)
    ride_time = person.am_arriving_time - person.am_departure_time1
    between_time = ride_time / (via_station_num + 1)

    if via_station_num >= 0
      person.update(am_arrival_time2: person.am_departure_time1 + between_time)
    end

    if via_station_num >= 1
      person.update(am_arrival_time3: person.am_arrival_time2 + between_time)
    end

    if via_station_num >= 2
      person.am_arrival_time3 + between_time
      person.update(am_arrival_time4: person.am_arrival_time3 + between_time)
    end

    if via_station_num >= 3
      person.update(am_arrival_time5: person.am_arrival_time4 + between_time)
    end

    if via_station_num >= 4
      person.update(am_arrival_time6: person.am_arrival_time5 + between_time)
    end

    if via_station_num >= 5
      person.update(am_arrival_time7: person.am_arrival_time6 + between_time)
    end

    if via_station_num >= 6
      person.update(am_arrival_time8: person.am_arrival_time7 + between_time)
    end
  end
end
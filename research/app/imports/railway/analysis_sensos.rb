class Railway::AnalysisSensos
  @station_list = []
  @between_time = []
  $file_name = nil
  $data = []

  def self.start(file_name = nil)
    $file_name = file_name

    puts '駅ランクをデフォルトセットします'
    set_default_rank

    puts "駅間時間を読み込みます"
    read_between_time_data

    puts "\n駅在留時間を計算します"
    set_between_time

    puts "\n駅ごとの人数を集計します\n終了後CSVに書き出します"
    aggregate_people

    puts "csvを解析します"
    read_aggregate_csv
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

    if via_station_num > 0
      # am_st2出発からam_st3到着までの時間を設定する
      start_st_idx = @station_list.pluck(:name).index(person.am_st2)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st3)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time3 = person.am_departure_time2 + ride_time
      end

      # am_st3滞留の時間を設定する
      if person.st3_id
        stay_time = Station.find(person.st3_id).transfer_time
        person.update(am_departure_time3: person.am_arrival_time3 + stay_time)
      else
        person.update(am_departure_time3: person.am_arrival_time3 + 120)
      end
    end

    if via_station_num > 1
      # am_st3出発からam_st4到着までの時間を設定する
      start_st_idx = @station_list.pluck(:name).index(person.am_st3)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st4)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time4 = person.am_departure_time3 + ride_time
      end

      # am_st4滞留の時間を設定する
      if person.st4_id
        stay_time = Station.find(person.st4_id).transfer_time
        person.update(am_departure_time4: person.am_arrival_time4 + stay_time)
      else
        person.update(am_departure_time4: person.am_arrival_time4 + 120)
      end
    end

    if via_station_num > 2
      # am_st4出発からam_st5到着までの時間を設定する
      start_st_idx = @station_list.pluck(:name).index(person.am_st4)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st5)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time5 = person.am_departure_time4 + ride_time
      end

      # am_st5滞留の時間を設定する
      if person.st5_id
        stay_time = Station.find(person.st5_id).transfer_time
        person.update(am_departure_time5: person.am_arrival_time5 + stay_time)
      else
        person.update(am_departure_time5: person.am_arrival_time5 + 120)
      end
    end

    if via_station_num > 3
      # am_st5出発からam_st6到着までの時間を設定する
      start_st_idx = @station_list.pluck(:name).index(person.am_st5)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st6)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time6 = person.am_departure_time5 + ride_time
      end

      # am_st6滞留の時間を設定する
      if person.st6_id
        stay_time = Station.find(person.st6_id).transfer_time
        person.update(am_departure_time6: person.am_arrival_time6 + stay_time)
      else
        person.update(am_departure_time6: person.am_arrival_time6 + 120)
      end
    end

    if via_station_num > 4
      # am_st6出発からam_st7到着までの時間を設定する
      start_st_idx = @station_list.pluck(:name).index(person.am_st6)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st7)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time7 = person.am_departure_time6 + ride_time
      end

      # am_st7滞留の時間を設定する
      if person.st7_id
        stay_time = Station.find(person.st7_id).transfer_time
        person.update(am_departure_time7: person.am_arrival_time7 + stay_time)
      else
        person.update(am_departure_time7: person.am_arrival_time7 + 120)
      end
    end

    if via_station_num > 5
      # am_st7出発からam_st8到着までの時間を設定する
      start_st_idx = @station_list.pluck(:name).index(person.am_st7)
      goal_st_idx = @station_list.pluck(:name).index(person.am_st8)
      if start_st_idx && goal_st_idx
        ride_time = @between_time[start_st_idx][goal_st_idx].to_i * 60
        person.am_arrival_time8 = person.am_departure_time7 + ride_time
      end

      # am_st8をでた時間を設定する
      if person.st8_id
        stay_time = Station.find(person.st8_id).transfer_time
        person.update(am_departure_time8: person.am_arrival_time8 + stay_time)
      else
        person.update(am_departure_time8: person.am_arrival_time8 + 120)
      end
    end

    person.save!
  end

  def self.default_set_via_station_time(person, via_station_num)
    # 駅滞留時間は150秒統一
    stay_time = 150
    ride_time = person.am_arriving_time - person.am_departure_time1
    between_time = (ride_time / (via_station_num + 1) ) - stay_time

    person.am_arrival_time1 = person.am_departure_time1 - stay_time

    if via_station_num >= 0
      person.am_arrival_time2 = person.am_departure_time1 + between_time
      person.am_departure_time2 = person.am_arrival_time2 + stay_time
    end

    if via_station_num >= 1
      person.am_arrival_time3 = person.am_departure_time2 + between_time
      person.am_departure_time3 = person.am_arrival_time3 + stay_time
    end

    if via_station_num >= 2
      person.am_arrival_time4 = person.am_departure_time3 + between_time
      person.am_departure_time4 = person.am_arrival_time4 + stay_time
    end

    if via_station_num >= 3
      person.am_arrival_time5 = person.am_departure_time4 + between_time
      person.am_departure_time5 = person.am_arrival_time5 + stay_time
    end

    if via_station_num >= 4
      person.am_arrival_time6 = person.am_departure_time5 + between_time
      person.am_departure_time6 = person.am_arrival_time6 + stay_time
    end

    if via_station_num >= 5
      person.am_arrival_time7 = person.am_departure_time6 + between_time
      person.am_departure_time7 = person.am_arrival_time7 + stay_time
    end

    if via_station_num >= 6
      person.am_arrival_time8 = person.am_departure_time7 + between_time
      person.am_departure_time8 = person.am_arrival_time8 + stay_time
    end

    person.save!
  end

  def self.aggregate_people
    # データセットを初期化
    1.upto(650) do |i|
      set = {st_id: i, bef0600: 0, af0600: 0, af0615: 0, af0630: 0, af0645: 0, af0700: 0, af0715: 0,
              af0730: 0, af0745: 0, af0800: 0, af0815: 0, af0830: 0, af0845: 0, af0900: 0,
               af0915: 0, af0930: 0, af0945: 0, af1000: 0, af1015: 0, af1030: 0, af1045: 0, af1100: 0,
                af1115: 0, af1130: 0, af1145: 0, af1200: 0,}
      $data << set
    end

    size = Person.all.size
    Person.find_each.with_index do |person, i|

      print "\r  Progress : #{i+1} /#{size}"

      magnification = person.magnification

      st_id = person.st1_id
      if st_id
        arrival_time = person.time_zone(person.am_arrival_time1)
        count_up(st_id, arrival_time, magnification) if arrival_time
        departure_time = person.time_zone(person.am_departure_time1)
        count_up(st_id, departure_time, magnification) if departure_time && arrival_time != departure_time
      end

      st_id = person.st2_id
      if st_id
        arrival_time = person.time_zone(person.am_arrival_time2)
        count_up(st_id, arrival_time, magnification) if arrival_time
        departure_time = person.time_zone(person.am_departure_time2)
        count_up(st_id, departure_time, magnification) if departure_time && arrival_time != departure_time
      end

      st_id = person.st3_id
      if st_id
        arrival_time = person.time_zone(person.am_arrival_time3)
        count_up(st_id, arrival_time, magnification) if arrival_time
        departure_time = person.time_zone(person.am_departure_time3)
        count_up(st_id, departure_time, magnification) if departure_time && arrival_time != departure_time
      end

      st_id = person.st4_id
      if st_id
        arrival_time = person.time_zone(person.am_arrival_time4)
        count_up(st_id, arrival_time, magnification) if arrival_time
        departure_time = person.time_zone(person.am_departure_time4)
        count_up(st_id, departure_time, magnification) if departure_time && arrival_time != departure_time
      end

      st_id = person.st5_id
      if st_id
        arrival_time = person.time_zone(person.am_arrival_time5)
        count_up(st_id, arrival_time, magnification) if arrival_time
        departure_time = person.time_zone(person.am_departure_time5)
        count_up(st_id, departure_time, magnification) if departure_time && arrival_time != departure_time
      end

      st_id = person.st6_id
      if st_id
        arrival_time = person.time_zone(person.am_arrival_time6)
        count_up(st_id, arrival_time, magnification) if arrival_time
        departure_time = person.time_zone(person.am_departure_time6)
        count_up(st_id, departure_time, magnification) if departure_time && arrival_time != departure_time
      end

      st_id = person.st7_id
      if st_id
        arrival_time = person.time_zone(person.am_arrival_time7)
        count_up(st_id, arrival_time, magnification) if arrival_time
        departure_time = person.time_zone(person.am_departure_time7)
        count_up(st_id, departure_time, magnification) if departure_time && arrival_time != departure_time
      end

      st_id = person.st8_id
      if st_id
        arrival_time = person.time_zone(person.am_arrival_time8)
        count_up(st_id, arrival_time, magnification) if arrival_time
        departure_time = person.time_zone(person.am_departure_time8)
        count_up(st_id, departure_time, magnification) if departure_time && arrival_time != departure_time
      end
    end

    puts "\nCSVに書き出しています"
    export_csv
  end

  def self.count_up(st_id, time, mag)
    case time
    when 'bef0600'
      $data[st_id - 1][:bef0600] += mag # magは拡大率
    when '0600'
      $data[st_id - 1][:af0600] += mag
    when '0615'
      $data[st_id - 1][:af0615] += mag
    when '0630'
      $data[st_id - 1][:af0630] += mag
    when '0645'
      $data[st_id - 1][:af0645] += mag
    when '0700'
      $data[st_id - 1][:af0700] += mag
    when '0715'
      $data[st_id - 1][:af0715] += mag
    when '0730'
      $data[st_id - 1][:af0730] += mag
    when '0745'
      $data[st_id - 1][:af0745] += mag
    when '0800'
      $data[st_id - 1][:af0800] += mag
    when '0815'
      $data[st_id - 1][:af0815] += mag
    when '0830'
      $data[st_id - 1][:af0830] += mag
    when '0845'
      $data[st_id - 1][:af0845] += mag
    when '0900'
      $data[st_id - 1][:af0900] += mag
    when '0915'
      $data[st_id - 1][:af0915] += mag
    when '0930'
      $data[st_id - 1][:af0930] += mag
    when '0945'
      $data[st_id - 1][:af0945] += mag
    when '1000'
      $data[st_id - 1][:af1000] += mag
    when '1015'
      $data[st_id - 1][:af1015] += mag
    when '1030'
      $data[st_id - 1][:af1030] += mag
    when '1045'
      $data[st_id - 1][:af1045] += mag
    when '1100'
      $data[st_id - 1][:af1100] += mag
    when '1115'
      $data[st_id - 1][:af1115] += mag
    when '1130'
      $data[st_id - 1][:af1130] += mag
    when '1145'
      $data[st_id - 1][:af1145] += mag
    when '1200'
      $data[st_id - 1][:af1200] += mag
    end
  end

  def self.export_csv
    CSV.open("app/imports/railway/data/aggregate_people_15min_#{$file_name}.csv",'w', headers: true) do |row|
      row << ['name', 'st_id', 'bef0600', 'af0600', 'af0615', 'af0630', 'af0645', 'af0700', 'af0715',
               'af0730', 'af0745', 'af0800', 'af0815', 'af0830', 'af0845', 'af0900', 'af0915',
               'af0930', 'af0945', 'af1000', 'af1015', 'af1030', 'af1045', 'af1100', 'af1115',
               'af1130', 'af1145', 'af1200']
      $data.each do |set|
        name = Station.find(set[:st_id]).name
        row << set.values.unshift(name)
      end
    end
  end

  def self.read_aggregate_csv
    CSV.read('app/imports/railway/data/aggregate_people_15min.csv', headers: false).each_with_index do |row, i|
      next if i == 0

      station = Station.find(row[1])
      row.shift(2)

      list = row.map {|num| num.to_i}
      station.update(peak_passengers: list.max)
    end

    CSV.read('app/imports/railway/data/aggregate_people_5min.csv', headers: false).each_with_index do |row, i|
      next if i == 0

      station = Station.find(row[1])
      row.shift(2)

      list = row.map {|num| num.to_i}
      station.update(peak_passengers_5min: list.max)
    end
  end

  def self.set_default_rank
    Station.all.each do |station|
      num = station.passengers.to_i

      if num > 1000000
        station.update(rank: 10)
      elsif num > 600000
        station.update(rank: 9)
      elsif num > 400000
        station.update(rank: 8)
      elsif num > 300000
        station.update(rank: 7)
      elsif num > 200000
        station.update(rank: 6)
      elsif num > 100000
        station.update(rank: 5)
      elsif num > 30000
        station.update(rank: 4)
      elsif num > 10000
        station.update(rank: 3)
      elsif num > 5000
        station.update(rank: 2)
      else
        station.update(rank: 1)
      end
    end
  end
end

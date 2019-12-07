class Railway::CalculateCsv
  $base_data_5min = []
  $base_data_15min = []

  def self.read_people_5min
    # 元のデータを取得しておく
    CSV.read('app/imports/railway/data/aggregate_people_5min.csv','r', headers: false).each do |row|
      $base_data_5min << row
    end

    # データが足りない駅に補完する
    complement_data_5min
    CSV.open('app/imports/railway/data/re_aggregate_people_5min.csv','w', headers: true) do |row|
      $base_data_5min.each do |datum|
        row << datum
      end
    end

    data = []
    data << ['name', 'st_id', 'bef0600',
              'af0600', 'af0605', 'af0610', 'af0615', 'af0620', 'af0625', 'af0630', 'af0635', 'af0640', 'af0645', 'af0650', 'af0655',
              'af0700', 'af0705', 'af0710', 'af0715', 'af0720', 'af0725', 'af0730', 'af0735', 'af0740', 'af0745', 'af0750', 'af0755',
              'af0800', 'af0805', 'af0810', 'af0815', 'af0820', 'af0825', 'af0830', 'af0835', 'af0840', 'af0845', 'af0850', 'af0855',
              'af0900', 'af0905', 'af0910', 'af0915', 'af0920', 'af0925', 'af0930', 'af0935', 'af0940', 'af0945', 'af0950', 'af0955',
              'af1000', 'af1005', 'af1010', 'af1015', 'af1020', 'af1025', 'af1030', 'af1035', 'af1040', 'af1045', 'af1050', 'af1055',
              'af1100', 'af1105', 'af1110', 'af1115', 'af1120', 'af1125', 'af1130', 'af1135', 'af1140', 'af1145', 'af1150', 'af1155',
              'af1200'
            ]

    CSV.read('app/imports/railway/data/re_aggregate_people_5min.csv','r', headers: false).each_with_index do |row, i|
      next if i == 0

      new_list = []
      station = Station.find(row[1])
      new_list << station.name
      new_list << station.id
      row.shift(2)

      list = row.map {|num| num.to_i}

      peak_passengers = list.max.to_f
      peak_passengers = 1 if peak_passengers == 0

      list.each do |li|
        val = (li.to_f / peak_passengers) * 100
        new_list << val.to_i
      end

      data << new_list
    end

    CSV.open('app/imports/railway/data/people_5min_percentage.csv','w') do |row|
      data.each do |datum|
        row << datum
      end
    end
  end

  def self.read_people_15min
    # 元のデータを取得しておく
    CSV.read('app/imports/railway/data/aggregate_people_15min.csv','r', headers: false).each do |row|
      $base_data_15min << row
    end

    # データが足りない駅に補完する
    complement_data_15min
    CSV.open('app/imports/railway/data/re_aggregate_people_15min.csv','w', headers: true) do |row|
      $base_data_15min.each do |datum|
        row << datum
      end
    end

    data = []
    data << ['name', 'st_id', 'bef0600',
              'af0600', 'af0615', 'af0630', 'af0645',
              'af0700', 'af0715', 'af0730', 'af0745',
              'af0800', 'af0815', 'af0830', 'af0845',
              'af0900', 'af0915', 'af0930', 'af0945',
              'af1000', 'af1015', 'af1030', 'af1045',
              'af1100', 'af1115', 'af1130', 'af1145',
              'af1200'
            ]

    CSV.read('app/imports/railway/data/re_aggregate_people_15min.csv','r', headers: false).each_with_index do |row, i|
      next if i == 0

      new_list = []
      station = Station.find(row[1])
      new_list << station.name
      new_list << station.id
      row.shift(2)

      list = row.map {|num| num.to_i}

      peak_passengers = list.max.to_f
      peak_passengers = 1 if peak_passengers == 0

      list.each do |li|
        val = (li.to_f / peak_passengers) * 100
        new_list << val.to_i
      end

      data << new_list
    end

    CSV.open('app/imports/railway/data/people_15min_percentage.csv','w') do |row|
      data.each do |datum|
        row << datum
      end
    end
  end

  def self.complement_data_5min
    $base_data_5min.each_with_index do |datum, i|
      next if i == 0

      station = Station.find(datum[1].to_i)
      model = model_area_5min(station.city.area)

      sum = model.sum.to_f
      # パーセントに変換
      model = model.map {|num| (num * 100 / sum).round(2) }

      datum.shift(2)
      datum = datum.map {|num| num.to_i }

      new_data = []
      if datum.sum < 10000 && datum.sum > 0
        passengers_sum = station.passengers / 3.5

        model.each do |percent|
          new_data << ( passengers_sum * (percent / 100.0) ).to_i
        end

        new_data = new_data.unshift(station.name, station.id)
        $base_data_5min[station.id] = new_data
      else
        $base_data_5min[station.id] = $base_data_5min[station.id].unshift(station.name, station.id)
      end
    end
  end

  def self.complement_data_15min
    $base_data_15min.each_with_index do |datum, i|
      next if i == 0

      station = Station.find(datum[1].to_i)
      model = model_area_15min(station.city.area)

      sum = model.sum.to_f
      # パーセントに変換
      model = model.map {|num| (num * 100 / sum).round(2) }

      datum.shift(2)
      datum = datum.map {|num| num.to_i }

      new_data = []
      if datum.sum < 10000 && datum.sum > 0
        passengers_sum = station.passengers / 3.5

        model.each do |percent|
          new_data << ( passengers_sum * (percent / 100.0) ).to_i
        end

        new_data = new_data.unshift(station.name, station.id)
        $base_data_15min[station.id] = new_data
      else
        $base_data_15min[station.id] = $base_data_15min[station.id].unshift(station.name, station.id)
      end
    end
  end

  def self.model_area_5min(area)
    case area.name
    when '東京' #大手町
      model = [6, 0, 0, 0, 0, 3, 2, 2, 2, 1, 2, 6, 7, 14, 10, 8, 14, 21, 36, 33,
        31, 58, 43, 50, 53, 70, 66, 74, 76, 71, 100, 86, 63, 55, 48, 44, 40, 46, 30, 22,
        19, 22, 15, 15, 11, 13, 11, 4, 9, 11, 16, 13, 7, 11, 3, 4, 4, 2, 4, 0,  
        0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 3, 2, 36]
    when '江戸川' #新小岩
      model = [9,3,0,0,1,0,2,10,21,32,46,22,34,15,31,37,21,71,59,77,53,76,86,81,
        100,84,78,94,72,62,55,34,33,30,23,27,29,21,19,3,16,2,0,19,16,12,63,2,0,3,
        6,1,0,5,3,3,6,7,4,0,1,3,1,0,0,0,0,0,2,0,0,3,3,20]
    when '練馬' #練馬
      model = [3,0,0,3,0,9,11,6,4,7,13,16,25,20,8,28,53,39,30,73,82,53,64,39,
        100,84,66,55,43,57,55,31,20,58,31,20,14,28,8,7,15,15,14,14,6,6,1,8,37,
        7,14,10,4,3,0,3,2,0,4,0,1,2,5,0,1,1,1,1,0,0,0,1,1,24]
    when '羽田' #蒲田
      model = [4,0,1,2,1,4,4,5,9,9,12,4,22,12,18,29,46,39,56,68,79,89,100,77,
        82,93,89,83,71,47,62,56,36,32,21,27,21,24,10,11,6,10,10,10,6,10,19,1,1,
        1,2,1,1,2,2,6,6,0,0,0,3,3,0,0,2,3,1,0,1,2,0,2,2,50]
    when '世田谷' #二子玉川
      model = [6,0,2,3,7,3,10,14,18,15,31,22,33,40,49,42,68,59,74,76,100,
        77,85,84,81,64,78,63,54,47,62,57,45,32,26,27,31,16,16,31,39,20,20,15,7,
        13,1,9,1,8,2,5,8,5,4,8,5,0,3,2,2,4,0,3,0,8,0,0,5,5,0,0,1,66]
    when '府中' #国分寺
      model = [4,0,0,3,2,8,20,9,18,20,10,19,13,26,33,69,64,65,77,57,74,71,55,70,
        52,57,72,100,96,51,75,46,16,24,13,18,23,14,9,11,15,7,4,4,8,9,2,2,7,24,13,
        6,1,5,0,0,3,2,5,0,4,1,4,4,4,7,9,0,0,0,4,0,2,29]
    when '八王子' #八王子
      model = [2,5,1,8,4,11,5,15,8,5,14,51,46,40,48,55,56,36,98,62,94,90,91,100,
        92,40,43,40,45,66,90,85,30,29,21,13,18,19,4,6,27,31,9,3,39,3,18,9,7,7,15,1,
        0,28,2,3,4,5,1,0,0,0,3,0,5,0,0,2,0,0,1,0,3,42]
    end

    model
  end

  def self.model_area_15min(area)
    case area.name
    when '東京' #大手町
      model = [3,0,1,1,6,13,30,54,60,85,100,85,55,41,24,15,9,14,8,5,2,0,0,0,2,16]
    when '江戸川' #新小岩
      model = [4,1,1,24,38,26,59,79,100,93,66,34,29,19,8,14,28,3,2,4,2,1,0,0,1,9]
    when '練馬' #練馬
      model = [1,1,7,8,22,28,59,94,100,90,70,48,27,22,18,14,20,10,4,1,3,3,1,0,1,12]
    when '羽田' #蒲田
      model = [2,1,4,8,19,26,58,96,100,95,72,54,28,19,9,12,10,2,2,4,2,2,2,1,1,25]
    when '世田谷' #二子玉川
      model = [2,2,7,19,37,49,81,87,100,78,63,53,33,24,29,15,5,6,8,5,3,3,3,2,0,28]
    when '府中' #国分寺
      model = [2,2,12,19,16,56,79,77,65,100,91,38,21,16,11,7,5,16,3,2,5,5,6,0,3,15]
    when '八王子' #八王子
      model = [1,5,7,10,33,50,66,75,100,44,76,47,17,12,16,18,10,9,11,4,0,1,2,0,2,16]
    end

    model
  end
end
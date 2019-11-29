class Railway::CalculateCsv
  $base_data = []

  def self.read_people_5min
    # 元のデータを取得しておく
    CSV.read('app/imports/railway/data/aggregate_people_5min.csv','r', headers: false).each do |row|
      $base_data << row
    end

    # データが足りない駅に補完する
    complement_data
    CSV.open('app/imports/railway/data/re_aggregate_people_5min.csv','w', headers: true) do |row|
      $base_data.each do |datum|
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

  def self.complement_data
    # 大手町の割合をモデルにする
    model = [6, 0, 0, 0, 0, 3, 2, 2, 2, 1, 2, 6, 7, 14, 10, 8, 14, 21, 36, 33, 31,
            58, 43, 50, 53, 70, 66, 74, 76, 71, 100, 86, 63, 55, 48, 44, 40, 46, 30,
            22, 19, 22, 15, 15, 11, 13, 11, 4, 9, 11, 16, 13, 7, 11, 3, 4, 4, 2, 4,
            0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 3, 2, 36]
    sum = model.sum.to_f
    # パーセントに変換
    model = model.map {|num| (num * 100 / sum).round(2) }

    $base_data.each_with_index do |datum, i|
      next if i == 0

      station = Station.find(datum[1].to_i)
      datum.shift(2)
      datum = datum.map {|num| num.to_i }

      new_data = []
      if datum.sum < 1500
        passengers_sum = station.passengers / 3.0

        model.each do |percent|
          new_data << ( passengers_sum * (percent / 100.0) ).to_i
        end

        new_data = new_data.unshift(station.name, station.id)
        $base_data[station.id] = new_data
      else
        $base_data[station.id] = $base_data[station.id].unshift(station.name, station.id)
      end
    end
  end
end
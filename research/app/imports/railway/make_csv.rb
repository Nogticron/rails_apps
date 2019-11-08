class Railway::MakeCsv
  @data_list = []

  def self.create_station_link
    links = []
    Line.all.each do |line|
      LineStation.where(line_id: line.id).each do |row|
        next_link = LineStation.find_by(id: row.id + 1, line_id: line.id)
        if next_link
          next_station = Station.find(next_link.station_id)
        else
          next_station = nil
        end

        # puts "#{line.name} #{row.station_name} #{row.station_id} -> #{next_station.id if next_station}"

        if next_station
          link = [row.station_id, next_station.id]
          links << link
        end

      end
    end

    #　辺のリストを書き出し
    CSV.open('app/imports/railway/data/station_links.csv','w', headers: false) do |row|
      links.each do |link|
        row << link
      end
    end

    # 座標を書き出し
    CSV.open('app/imports/railway/data/station_pos.csv','w', headers: false) do |row|
      Station.all.each do |station|
        row << [station.lat.to_f * 1000000, station.lon.to_f * 1000000, station.id]
      end
    end
  end

  def self.make_sensos
    File.open("H17_root.txt", mode = "rt") do |f|
      _row = []
      cnt = 0

      f.each_with_index do |line, i|
        if i % 4 == 0
          _row[cnt] = line.chomp.split.join(",")
        elsif i % 4 == 1
          str_array = line.chomp.split

          if str_array.length == 11
            str_array.insert(-2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
          elsif str_array.length == 13
            str_array.insert(-2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
          elsif str_array.length == 15
            str_array.insert(-2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
          elsif str_array.length == 17
            str_array.insert(-2, nil, nil, nil, nil, nil, nil, nil, nil)
          elsif str_array.length == 19
            str_array.insert(-2, nil, nil, nil, nil, nil, nil)
          elsif str_array.length == 21
            str_array.insert(-2, nil, nil, nil, nil)
          elsif str_array.length == 23
            str_array.insert(-2, nil, nil)
          end
          _row[cnt] += "," + str_array.join(",")

        elsif i % 4 == 2
          str_array = line.chomp.split

          if str_array.length == 9
            str_array.insert(-2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
          elsif str_array.length == 11
            str_array.insert(-2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
          elsif str_array.length == 13
            str_array.insert(-2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
          elsif str_array.length == 15
            str_array.insert(-2, nil, nil, nil, nil, nil, nil, nil, nil)
          elsif str_array.length == 17
            str_array.insert(-2, nil, nil, nil, nil, nil, nil)
          elsif str_array.length == 19
            str_array.insert(-2, nil, nil, nil, nil)
          elsif str_array.length == 21
            str_array.insert(-2, nil, nil)
          end
          _row[cnt] += "," + str_array.join(",")

        elsif i % 4 == 3
          str_array = line.chomp.split

          if str_array.length == 1
            str_array.push(nil, nil, nil)
          elsif str_array.length == 2
            str_array.push(nil, nil)
          elsif str_array.length == 3
            str_array.push(nil)
          end
          _row[cnt] += "," + str_array.join(",")

          @data_list << Array(_row[cnt].split(","))
          cnt += 1
        end
      end
    end

    CSV.open('H17_utf-8.csv','w', headers: true) do |row|
      row << ["レコード番号","性別","年齢","居住地ゾーン","定期券保有","種類","拡大率",
              "経路1-利用経路数","経路1-移動目的","経路1-出発地区分","出発地ゾーン","経路1-目的地区分","目的地ゾーン","経路1-乗車時刻","経路1-降車時刻",
              "経路1-乗車駅1","経路1-降車駅1","経路1-乗車駅2","経路1-降車駅2","経路1-乗車駅3","経路1-降車駅3","経路1-乗車駅4","経路1-降車駅4",
              "経路1-乗車駅5","経路1-降車駅5","経路1-乗車駅6","経路1-降車駅6","経路1-乗車駅7","経路1-降車駅7","経路1-乗車駅8","経路1-乗車駅8",
              "経路1-列車種別:(x利用経路数)",
              "経路2-利用経路数","経路2-移動目的","経路2-出発地区分","経路2-目的地区分","経路2-乗車時刻","経路2-降車時刻",
              "経路2-乗車駅1","経路2-降車駅1","経路2-乗車駅2","経路2-降車駅2","経路2-乗車駅3","経路2-降車駅3","経路2-乗車駅4","経路2-降車駅4",
              "経路2-乗車駅5","経路2-降車駅5","経路2-乗車駅6","経路2-降車駅6","経路2-乗車駅7","経路2-降車駅7","経路2-乗車駅8","経路2-乗車駅8",
              "経路2-列車種別:(x利用経路数)",
              "(帰宅経路)乗車時刻","降車時刻","乗車駅","降車駅"]
      @data_list.each do |data|
        row << data
      end
    end
  end
end

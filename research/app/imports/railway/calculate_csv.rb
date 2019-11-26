class Railway::CalculateCsv
  def self.read_people_5min
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

    CSV.read('app/imports/railway/data/aggregate_people_5min.csv','r', headers: false).each_with_index do |row, i|
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
end
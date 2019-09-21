# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

areas = [['東京', 'tokyo'], ['江戸川', 'edogawa'], ['練馬', 'nerima'], ['羽田', 'haneda'],
					['世田谷', 'setagaya'], ['府中', 'fuchu'], ['八王子', 'hachioji']]
areas.each do |area|
	next if Area.exists?(name: area[0])

	Area.create(name: area[0], e_name: area[1])
end
puts 'エリアを作成しました'

Railway::CsvImport.get
Weather::ImportWeatherData.get
ImportCityData.get
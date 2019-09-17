class ImportCityData

	def self.get
		puts '東京都のデータを取得します'
		CSV.read('app/imports/city_data.csv', headers: true).each do |row|
			next if row['地域'] == '東京都総数' || row['地域'] == '区部'
			next if City.find_by(name: row['地域'])

			city = City.new
			city.name = row['地域']
			city.area_code = row['地域コード']
			city.day_population = row['昼間人口／総数（人）']
			city.resident_population = row['常住人口／総数（人）']
			city.day_night_ratio = row['昼夜間人口比率／総数（％）']
			city.area = row['面積（キロ平方メートル）']
			city.day_density = row['人口密度／昼間人口（人/キロ平方メートル）']
			city.resident_density = row['人口密度／常住人口（人/キロ平方メートル）']
			city.save!
		end
		puts '東京都のデータを取得しました'
	end
end
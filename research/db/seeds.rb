# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CreateAreaCity.create_area
Railway::CsvImport.get
Weather::ImportWeatherData.get
ImportCityData.get
Railway::ScrapeStationCity.get
CreateAreaCity.create_area_city_relations
Railway::ScrapeStationRank.get

Railway::ReadSensos.start
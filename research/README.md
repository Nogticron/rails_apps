reserch
======

## UTF−8に変換
nkf -w --overwrite (ファイル名)

## 準備

```
$ rails db:create

$ rails db:migrate

$ rails db:seed
```
-> seedの実行内容
```rb
CreateAreaCity.create_area
Railway::StationImport.get
# Weather::ImportWeatherData.get
ImportCityData.get
Railway::LinkStationCity.get
CreateAreaCity.create_area_city_relation
Railway::ScrapeStationRank.get

Railway::ReadSensos.start
# 総データ数14万件のため途中で止めても良い
# 途中で止めたら　$ rails runner 'Railway::ReadSensos.set_ids' を実行
Railway::AnalysisSensos.start
```
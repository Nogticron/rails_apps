駅間走行時間・駅滞留時間をセット
rails runner "Railway::AnalysisSensos.start(file_name)"


5分刻みの集計
rails runner "Railway::CalculateCsv.read_people_5min"

15分刻みの集計
rails runner "Railway::CalculateCsv.read_people_15min"

データの補完
rails runner "Railway::CalculateCsv.read_people_5min(area_name)"

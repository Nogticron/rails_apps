class CreateAreaCity

  def self.create_area
    areas = [['東京', 'tokyo'], ['江戸川', 'edogawa'], ['練馬', 'nerima'], ['羽田', 'haneda'],
					['世田谷', 'setagaya'], ['府中', 'fuchu'], ['八王子', 'hachioji']]
    areas.each do |area|
      next if Area.exists?(name: area[0])

      Area.create(name: area[0], e_name: area[1])
    end
    puts 'エリアを作成しました'
  end

  def self.create_area_city_relation
    puts 'エリアと市区町村のリレーションを作成します'
    tokyo_area = ['千代田区', '文京区', '豊島区', '中央区', '新宿区', '渋谷区', '港区', '荒川区', '台東区']
    edogawa_area = ['江戸川区', '葛飾区', '足立区', '墨田区', '江東区']
    nerima_area = ['北区', '板橋区', '練馬区', '中野区', '東久留米市', '西東京市', '武蔵野市', '清瀬市', '東村山市']
    haneda_area = ['品川区', '大田区']
    setagaya_area = ['世田谷区', '目黒区', '杉並区', '三鷹市', '狛江市',]
    fuchu_area = ['調布市', '府中市', '稲城市', '多摩市', '町田市', '日野市', '国立市', '小金井市', '小平市', '国分寺市', '立川市', '東大和市']
    hachioji_area = ['八王子市', '昭島市', '武蔵村山市', '瑞穂町', '福生市', '羽村市', 'あきる野市', '日の出町', '青梅市', '奥多摩町', '檜原村']
    area_list = ['東京', '江戸川', '練馬', '羽田', '世田谷', '府中', '八王子']

    [tokyo_area, edogawa_area, nerima_area, haneda_area, setagaya_area, fuchu_area, hachioji_area]
      .zip(area_list).each do |area, area_name|
      area_id = Area.find_by(name: area_name).id

      area.each do |city_name|
        city = City.find_by(name: city_name)
        city.update(area_id: area_id)
      end
    end
  end
end
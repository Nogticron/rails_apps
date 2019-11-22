class Person < ApplicationRecord

  def time_zone(time)
    begin
      time = (time.in_time_zone("Tokyo") - (3600 * 9))
    rescue => exception
      return nil
    end

    if time < Time.parse('2000/01/01 06:00:00')
      'bef0600'
    elsif Time.parse('2000/01/01 06:00:00') <= time && time < Time.parse('2000/01/01 06:05:00')
      '0600'
    elsif Time.parse('2000/01/01 06:05:00') <= time && time < Time.parse('2000/01/01 06:10:00')
      '0605'
    elsif Time.parse('2000/01/01 06:10:00') <= time && time < Time.parse('2000/01/01 06:15:00')
      '0610'
    elsif Time.parse('2000/01/01 06:15:00') <= time && time < Time.parse('2000/01/01 06:20:00')
      '0615'
    elsif Time.parse('2000/01/01 06:20:00') <= time && time < Time.parse('2000/01/01 06:25:00')
      '0620'
    elsif Time.parse('2000/01/01 06:25:00') <= time && time < Time.parse('2000/01/01 06:30:00')
      '0625'
    elsif Time.parse('2000/01/01 06:30:00') <= time && time < Time.parse('2000/01/01 06:35:00')
      '0630'
    elsif Time.parse('2000/01/01 06:35:00') <= time && time < Time.parse('2000/01/01 06:40:00')
      '0635'
    elsif Time.parse('2000/01/01 06:40:00') <= time && time < Time.parse('2000/01/01 06:45:00')
      '0640'
    elsif Time.parse('2000/01/01 06:45:00') <= time && time < Time.parse('2000/01/01 06:50:00')
      '0645'
    elsif Time.parse('2000/01/01 06:50:00') <= time && time < Time.parse('2000/01/01 06:55:00')
      '0650'
    elsif Time.parse('2000/01/01 06:55:00') <= time && time < Time.parse('2000/01/01 07:00:00')
      '0655'
    elsif Time.parse('2000/01/01 07:00:00') <= time && time < Time.parse('2000/01/01 07:05:00')
      '0700'
    elsif Time.parse('2000/01/01 07:05:00') <= time && time < Time.parse('2000/01/01 07:10:00')
      '0705'
    elsif Time.parse('2000/01/01 07:10:00') <= time && time < Time.parse('2000/01/01 07:15:00')
      '0710'
    elsif Time.parse('2000/01/01 07:15:00') <= time && time < Time.parse('2000/01/01 07:20:00')
      '0715'
    elsif Time.parse('2000/01/01 07:20:00') <= time && time < Time.parse('2000/01/01 07:25:00')
      '0720'
    elsif Time.parse('2000/01/01 07:25:00') <= time && time < Time.parse('2000/01/01 07:30:00')
      '0725'
    elsif Time.parse('2000/01/01 07:30:00') <= time && time < Time.parse('2000/01/01 07:35:00')
      '0730'
    elsif Time.parse('2000/01/01 07:35:00') <= time && time < Time.parse('2000/01/01 07:40:00')
      '0735'
    elsif Time.parse('2000/01/01 07:40:00') <= time && time < Time.parse('2000/01/01 07:45:00')
      '0740'
    elsif Time.parse('2000/01/01 07:45:00') <= time && time < Time.parse('2000/01/01 07:50:00')
      '0745'
    elsif Time.parse('2000/01/01 07:50:00') <= time && time < Time.parse('2000/01/01 07:55:00')
      '0750'
    elsif Time.parse('2000/01/01 07:55:00') <= time && time < Time.parse('2000/01/01 08:00:00')
      '0755'
    elsif Time.parse('2000/01/01 08:00:00') <= time && time < Time.parse('2000/01/01 08:05:00')
      '0800'
    elsif Time.parse('2000/01/01 08:05:00') <= time && time < Time.parse('2000/01/01 08:10:00')
      '0805'
    elsif Time.parse('2000/01/01 08:10:00') <= time && time < Time.parse('2000/01/01 08:15:00')
      '0810'
    elsif Time.parse('2000/01/01 08:15:00') <= time && time < Time.parse('2000/01/01 08:20:00')
      '0815'
    elsif Time.parse('2000/01/01 08:20:00') <= time && time < Time.parse('2000/01/01 08:25:00')
      '0820'
    elsif Time.parse('2000/01/01 08:25:00') <= time && time < Time.parse('2000/01/01 08:30:00')
      '0825'
    elsif Time.parse('2000/01/01 08:30:00') <= time && time < Time.parse('2000/01/01 08:35:00')
      '0830'
    elsif Time.parse('2000/01/01 08:35:00') <= time && time < Time.parse('2000/01/01 08:40:00')
      '0835'
    elsif Time.parse('2000/01/01 08:40:00') <= time && time < Time.parse('2000/01/01 08:45:00')
      '0840'
    elsif Time.parse('2000/01/01 08:45:00') <= time && time < Time.parse('2000/01/01 08:50:00')
      '0845'
    elsif Time.parse('2000/01/01 08:50:00') <= time && time < Time.parse('2000/01/01 08:55:00')
      '0850'
    elsif Time.parse('2000/01/01 08:55:00') <= time && time < Time.parse('2000/01/01 09:00:00')
      '0855'
    elsif Time.parse('2000/01/01 09:00:00') <= time && time < Time.parse('2000/01/01 09:05:00')
      '0900'
    elsif Time.parse('2000/01/01 09:05:00') <= time && time < Time.parse('2000/01/01 09:10:00')
      '0905'
    elsif Time.parse('2000/01/01 09:10:00') <= time && time < Time.parse('2000/01/01 09:15:00')
      '0910'
    elsif Time.parse('2000/01/01 09:15:00') <= time && time < Time.parse('2000/01/01 09:20:00')
      '0915'
    elsif Time.parse('2000/01/01 09:20:00') <= time && time < Time.parse('2000/01/01 09:25:00')
      '0920'
    elsif Time.parse('2000/01/01 09:25:00') <= time && time < Time.parse('2000/01/01 09:30:00')
      '0925'
    elsif Time.parse('2000/01/01 09:30:00') <= time && time < Time.parse('2000/01/01 09:35:00')
      '0930'
    elsif Time.parse('2000/01/01 09:35:00') <= time && time < Time.parse('2000/01/01 09:40:00')
      '0935'
    elsif Time.parse('2000/01/01 09:40:00') <= time && time < Time.parse('2000/01/01 09:45:00')
      '0940'
    elsif Time.parse('2000/01/01 09:45:00') <= time && time < Time.parse('2000/01/01 09:50:00')
      '0945'
    elsif Time.parse('2000/01/01 09:50:00') <= time && time < Time.parse('2000/01/01 09:55:00')
      '0950'
    elsif Time.parse('2000/01/01 09:55:00') <= time && time < Time.parse('2000/01/01 10:00:00')
      '0955'
    elsif Time.parse('2000/01/01 10:00:00') <= time && time < Time.parse('2000/01/01 10:05:00')
      '1000'
    elsif Time.parse('2000/01/01 10:05:00') <= time && time < Time.parse('2000/01/01 10:10:00')
      '1005'
    elsif Time.parse('2000/01/01 10:10:00') <= time && time < Time.parse('2000/01/01 10:15:00')
      '1010'
    elsif Time.parse('2000/01/01 10:15:00') <= time && time < Time.parse('2000/01/01 10:20:00')
      '1015'
    elsif Time.parse('2000/01/01 10:20:00') <= time && time < Time.parse('2000/01/01 10:25:00')
      '1020'
    elsif Time.parse('2000/01/01 10:25:00') <= time && time < Time.parse('2000/01/01 10:30:00')
      '1025'
    elsif Time.parse('2000/01/01 10:30:00') <= time && time < Time.parse('2000/01/01 10:35:00')
      '1030'
    elsif Time.parse('2000/01/01 10:35:00') <= time && time < Time.parse('2000/01/01 10:40:00')
      '1035'
    elsif Time.parse('2000/01/01 10:40:00') <= time && time < Time.parse('2000/01/01 10:45:00')
      '1040'
    elsif Time.parse('2000/01/01 10:45:00') <= time && time < Time.parse('2000/01/01 10:50:00')
      '1045'
    elsif Time.parse('2000/01/01 10:50:00') <= time && time < Time.parse('2000/01/01 10:55:00')
      '1050'
    elsif Time.parse('2000/01/01 10:55:00') <= time && time < Time.parse('2000/01/01 11:00:00')
      '1055'
    elsif Time.parse('2000/01/01 11:00:00') <= time && time < Time.parse('2000/01/01 11:05:00')
      '1100'
    elsif Time.parse('2000/01/01 11:05:00') <= time && time < Time.parse('2000/01/01 11:10:00')
      '1105'
    elsif Time.parse('2000/01/01 11:10:00') <= time && time < Time.parse('2000/01/01 11:15:00')
      '1110'
    elsif Time.parse('2000/01/01 11:15:00') <= time && time < Time.parse('2000/01/01 11:20:00')
      '1115'
    elsif Time.parse('2000/01/01 11:20:00') <= time && time < Time.parse('2000/01/01 11:25:00')
      '1120'
    elsif Time.parse('2000/01/01 11:25:00') <= time && time < Time.parse('2000/01/01 11:30:00')
      '1125'
    elsif Time.parse('2000/01/01 11:30:00') <= time && time < Time.parse('2000/01/01 11:35:00')
      '1130'
    elsif Time.parse('2000/01/01 11:35:00') <= time && time < Time.parse('2000/01/01 11:40:00')
      '1135'
    elsif Time.parse('2000/01/01 11:40:00') <= time && time < Time.parse('2000/01/01 11:45:00')
      '1140'
    elsif Time.parse('2000/01/01 11:45:00') <= time && time < Time.parse('2000/01/01 11:50:00')
      '1145'
    elsif Time.parse('2000/01/01 11:50:00') <= time && time < Time.parse('2000/01/01 11:55:00')
      '1150'
    elsif Time.parse('2000/01/01 11:55:00') <= time && time < Time.parse('2000/01/01 12:00:00')
      '1155'
    elsif Time.parse('2000/01/01 12:00:00') <= time
      '1200'
    end
  end
end

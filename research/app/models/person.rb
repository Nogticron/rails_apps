class Person < ApplicationRecord

  def time_zone(time)
    begin
      time = (time.in_time_zone("Tokyo") - (3600 * 9))
    rescue => exception
      return nil
    end

    if time < Time.parse('2000/01/01 06:00:00')
      'bef0600'
    elsif Time.parse('2000/01/01 06:00:00') <= time && time < Time.parse('2000/01/01 06:15:00')
      '0600'
    elsif Time.parse('2000/01/01 06:15:00') <= time && time < Time.parse('2000/01/01 06:30:00')
      '0615'
    elsif Time.parse('2000/01/01 06:30:00') <= time && time < Time.parse('2000/01/01 06:45:00')
      '0630'
    elsif Time.parse('2000/01/01 06:45:00') <= time && time < Time.parse('2000/01/01 07:00:00')
      '0645'
    elsif Time.parse('2000/01/01 07:00:00') <= time && time < Time.parse('2000/01/01 07:15:00')
      '0700'
    elsif Time.parse('2000/01/01 07:15:00') <= time && time < Time.parse('2000/01/01 07:30:00')
      '0715'
    elsif Time.parse('2000/01/01 07:30:00') <= time && time < Time.parse('2000/01/01 07:45:00')
      '0730'
    elsif Time.parse('2000/01/01 07:45:00') <= time && time < Time.parse('2000/01/01 08:00:00')
      '0745'
    elsif Time.parse('2000/01/01 08:00:00') <= time && time < Time.parse('2000/01/01 08:15:00')
      '0800'
    elsif Time.parse('2000/01/01 08:15:00') <= time && time < Time.parse('2000/01/01 08:30:00')
      '0815'
    elsif Time.parse('2000/01/01 08:30:00') <= time && time < Time.parse('2000/01/01 08:45:00')
      '0830'
    elsif Time.parse('2000/01/01 08:45:00') <= time && time < Time.parse('2000/01/01 09:00:00')
      '0845'
    elsif Time.parse('2000/01/01 09:00:00') <= time && time < Time.parse('2000/01/01 09:15:00')
      '0900'
    elsif Time.parse('2000/01/01 09:15:00') <= time && time < Time.parse('2000/01/01 09:30:00')
      '0915'
    elsif Time.parse('2000/01/01 09:30:00') <= time && time < Time.parse('2000/01/01 09:45:00')
      '0930'
    elsif Time.parse('2000/01/01 09:45:00') <= time && time < Time.parse('2000/01/01 10:00:00')
      '0945'
    elsif Time.parse('2000/01/01 10:00:00') <= time && time < Time.parse('2000/01/01 10:15:00')
      '1000'
    elsif Time.parse('2000/01/01 10:15:00') <= time && time < Time.parse('2000/01/01 10:30:00')
      '1015'
    elsif Time.parse('2000/01/01 10:30:00') <= time && time < Time.parse('2000/01/01 10:45:00')
      '1030'
    elsif Time.parse('2000/01/01 10:45:00') <= time && time < Time.parse('2000/01/01 11:00:00')
      '1045'
    elsif Time.parse('2000/01/01 11:00:00') <= time && time < Time.parse('2000/01/01 11:15:00')
      '1100'
    elsif Time.parse('2000/01/01 11:15:00') <= time && time < Time.parse('2000/01/01 11:30:00')
      '1115'
    elsif Time.parse('2000/01/01 11:30:00') <= time && time < Time.parse('2000/01/01 11:45:00')
      '1130'
    elsif Time.parse('2000/01/01 11:45:00') <= time && time < Time.parse('2000/01/01 12:00:00')
      '1145'
    elsif Time.parse('2000/01/01 12:00:00') <= time
      '1200'
    end
  end
end

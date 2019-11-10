class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.integer :record_id, null: false
      t.integer :age, null: false
      t.boolean :passport, null: false
      t.integer :magnification, null: false

      t.time :am_arriving_time
      t.string :am_st1, null: false
      t.integer :st1_id
      t.time :am_arrival_time1
      t.time :am_departure_time1
      t.string :am_st2
      t.integer :st2_id
      t.time :am_arrival_time2
      t.time :am_departure_time2
      t.string :am_st3
      t.integer :st3_id
      t.time :am_arrival_time3
      t.time :am_departure_time3
      t.string :am_st4
      t.integer :st4_id
      t.time :am_arrival_time4
      t.time :am_departure_time4
      t.string :am_st5
      t.integer :st5_id
      t.time :am_arrival_time5
      t.time :am_departure_time5
      t.string :am_st6
      t.integer :st6_id
      t.time :am_arrival_time6
      t.time :am_departure_time6
      t.string :am_st7
      t.integer :st7_id
      t.time :am_arrival_time7
      t.time :am_departure_time7
      t.string :am_st8
      t.integer :st8_id
      t.time :am_arrival_time8
      t.time :am_departure_time8
    end
  end
end

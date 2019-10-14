class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.integer :record_id, null: false
      t.integer :age, null: false
      t.boolean :passport, null: false
      t.integer :magnification, null: false

      t.time :s_arriving_time
      t.string :r1_st1, null: false
      t.integer :st1_id
      t.time :s_time
      t.string :r1_st2
      t.integer :st2_id
      t.time :r1_time2
      t.string :r1_st3
      t.integer :st3_id
      t.time :r1_time3
      t.string :r1_st4
      t.integer :st4_id
      t.time :r1_time4
      t.string :r1_st5
      t.integer :st5_id
      t.time :r1_time5
      t.string :r1_st6
      t.integer :st6_id
      t.time :r1_time6
      t.string :r1_st7
      t.integer :st7_id
      t.time :r1_time7
      t.string :r1_st8
      t.integer :st8_id
      t.time :r1_time8
    end
  end
end

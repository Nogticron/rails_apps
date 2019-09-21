class CreateWeathers < ActiveRecord::Migration[5.2]
  def change
    create_table :weathers do |t|

      t.references :area, add_foreign_key: true
      t.date :date, null: false
      t.float :max_temp, null: false
      t.float :min_temp, null: false
      t.string :weather_9, null: false
      t.string :weather_12, null: false
      t.string :weather_15, null: false
      t.string :amount, null: false
    end
  end
end

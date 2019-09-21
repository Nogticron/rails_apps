class CreateWeathers < ActiveRecord::Migration[5.2]
  def change
    create_table :weathers do |t|

      t.references :area, add_foreign_key: true
      t.date :date, null: false
      t.time :time, null: false
      t.float :temperture
      t.integer :temp_quality
      t.float :precipitation
      t.boolean :is_occurrence
      t.integer :precip_quality
      t.integer :weather_state
      t.integer :weather_quality
    end
  end
end

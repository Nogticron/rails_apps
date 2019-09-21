class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|

      t.references :area, add_foreign_key: true
      t.string :name, null: false
      t.integer :area_code, null: false
      t.integer :day_population, null: false
      t.integer :resident_population, null: false
      t.float :day_night_ratio, null: false
      t.float :area, null: false
      t.float :day_density, null: false
      t.float :resident_density, null: false
      t.boolean :tour_spot, default: false, null: false
    end
  end
end

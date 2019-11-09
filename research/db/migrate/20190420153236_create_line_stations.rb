class CreateLineStations < ActiveRecord::Migration[5.2]
  def change
    create_table :line_stations do |t|
      t.references :line, add_foreign_key: true
      t.references :station, add_foreign_key: true
      t.string :line_name
      t.string :station_name
      t.string :home_lat
      t.string :home_lon
      t.integer :number
    end
  end
end

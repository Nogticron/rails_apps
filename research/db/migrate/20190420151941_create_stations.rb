class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.string :lon, null: false
      t.string :lat, null: false
    end
  end
end

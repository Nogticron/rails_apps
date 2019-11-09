class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|

      t.references :city, add_foreign_key: true
      t.string :name, null: false
      t.string :lon, null: false
      t.string :lat, null: false

      t.integer :passengers, default: 0
      t.integer :rank
    end
  end
end

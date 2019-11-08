class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|

      t.references :city, add_foreign_key: true
      t.string :name, null: false
      t.string :lon, null: false
      t.string :lat, null: false

      t.integer :rank, default: 1

      t.integer :before_0600, default: 0
      t.integer :between_0600_0620, default: 0
      t.integer :between_0620_0640, default: 0
      t.integer :between_0640_0700, default: 0
      t.integer :between_0700_0720, default: 0
      t.integer :between_0720_0740, default: 0
      t.integer :between_0740_0800, default: 0
      t.integer :between_0800_0820, default: 0
      t.integer :between_0820_0840, default: 0
      t.integer :between_0840_0900, default: 0
      t.integer :between_0900_0920, default: 0
      t.integer :between_0920_0940, default: 0
      t.integer :between_0940_1000, default: 0
      t.integer :between_1000_1020, default: 0
      t.integer :between_1020_1040, default: 0
      t.integer :between_1040_1100, default: 0
      t.integer :after_1100, default: 0
    end
  end
end

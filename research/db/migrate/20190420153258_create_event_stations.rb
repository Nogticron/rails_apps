class CreateEventStations < ActiveRecord::Migration[5.2]
  def change
    create_table :event_stations do |t|
      t.references :event, add_foreign_key: true
      t.references :station, add_foreign_key: true
    end
  end
end

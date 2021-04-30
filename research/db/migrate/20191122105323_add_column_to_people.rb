class AddColumnToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :stations, :peak_passengers_5min, :integer, after: :peak_passengers
  end
end

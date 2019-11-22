class AddColumnToStation < ActiveRecord::Migration[5.2]
  def change
    add_column :stations, :peak_passengers, :integer, after: :passengers
  end
end

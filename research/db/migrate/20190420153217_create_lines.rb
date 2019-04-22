class CreateLines < ActiveRecord::Migration[5.2]
  def change
    create_table :lines do |t|
      t.string :name, null: false
      t.string :corporation, null: false
    end
  end
end

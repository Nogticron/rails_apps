class CreateAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :areas do |t|

      t.string :name, null: false
      t.string :e_name, null: false
    end
  end
end

class CreateHides < ActiveRecord::Migration[5.2]
  def change
    create_table :hides do |t|
      t.integer :myuser_id
      t.string :element

      t.timestamps
    end
  end
end

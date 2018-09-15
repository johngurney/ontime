class CreateUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :updates do |t|
      t.integer :myuser_id
      t.integer :task_id
      t.text :comments

      t.timestamps
    end
  end
end

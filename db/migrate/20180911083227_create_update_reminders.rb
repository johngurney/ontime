class CreateUpdateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :update_reminders do |t|
      t.integer :type
      t.float :proportion
      t.float :start_end
      t.float :offset
      t.datetime :day_time

      t.timestamps
    end
  end
end

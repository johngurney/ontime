class ChangeColForUpdateReminder < ActiveRecord::Migration[5.2]
  def change
    add_column :update_reminders, :repeat_time1, :datetime
  end
end

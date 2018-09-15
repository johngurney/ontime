class AddColsToUpdateReminder < ActiveRecord::Migration[5.2]
  def change
    add_column :update_reminders, :window_start_date, :datetime
    add_column :update_reminders, :window_end_date, :datetime
  end
end

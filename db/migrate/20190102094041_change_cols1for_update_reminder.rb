class ChangeCols1forUpdateReminder < ActiveRecord::Migration[5.2]
  def change
    remove_column :update_reminders, :repeat_time
    rename_column :update_reminders, :repeat_time1, :repeat_time
  end
end

class ChangecolinUpdateReminder < ActiveRecord::Migration[5.2]
  def change
    remove_column :update_reminders, :update_window_hours
    remove_column :update_reminders, :update_window_days
    remove_column :update_reminders, :window_start_date
    remove_column :update_reminders, :window_end_date
    remove_column :update_reminders, :updated_flag

    add_column :update_reminders, :update_window_length, :datetime
    add_column :update_reminders, :email_sent_time_date, :datetime

  end
end

class AdjustUpdateReminders < ActiveRecord::Migration[5.2]
  def change
    change_column :update_reminders, :offset, :integer
    rename_column :update_reminders, :offset, :offset_days
    add_column :update_reminders, :offset_hours, :string

    change_column :update_reminders, :day_time, :integer
    rename_column :update_reminders, :day_time, :repeat_weekday
    add_column :update_reminders, :repeat_time, :string

    add_column :update_reminders, :allow_email_flag, :boolean
    add_column :update_reminders, :update_window_percentage_flag, :boolean
    add_column :update_reminders, :update_window_days, :integer
    add_column :update_reminders, :update_window_hours, :string
    add_column :update_reminders, :update_window_percentage, :float

  end
end

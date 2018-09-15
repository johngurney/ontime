class AddReminderSchIdToUpdateReminders < ActiveRecord::Migration[5.2]
  def change
    add_column :update_reminders, :reminder_schedule_id, :integer
  end
end

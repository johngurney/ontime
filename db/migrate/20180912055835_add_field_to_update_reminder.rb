class AddFieldToUpdateReminder < ActiveRecord::Migration[5.2]
  def change
    add_column :update_reminders, :is_for_task, :boolean
  end
end

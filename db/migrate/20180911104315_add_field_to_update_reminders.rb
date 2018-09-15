class AddFieldToUpdateReminders < ActiveRecord::Migration[5.2]
  def change
    add_column :update_reminders, :task_id, :integer
  end
end

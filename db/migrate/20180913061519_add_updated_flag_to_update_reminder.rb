class AddUpdatedFlagToUpdateReminder < ActiveRecord::Migration[5.2]
  def change
    add_column :update_reminders, :updated_flag, :boolean
  end
end

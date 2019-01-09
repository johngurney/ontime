class Changecol1inUpdateReminder < ActiveRecord::Migration[5.2]
  def change
    remove_column :update_reminders, :update_window_length
    add_column :update_reminders, :update_window_length_in_seconds, :integer

  end
end

class RenameColInUpateReminders < ActiveRecord::Migration[5.2]
  def change
    rename_column :update_reminders, :type, :update_type
  end
end

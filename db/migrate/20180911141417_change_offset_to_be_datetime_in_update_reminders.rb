class ChangeOffsetToBeDatetimeInUpdateReminders < ActiveRecord::Migration[5.2]
  def change
    change_column :update_reminders, :offset, :datatime
  end
end

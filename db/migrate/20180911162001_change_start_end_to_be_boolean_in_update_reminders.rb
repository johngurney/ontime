class ChangeStartEndToBeBooleanInUpdateReminders < ActiveRecord::Migration[5.2]
  def change
    change_column :update_reminders, :start_end, 'boolean USING (start_end::int::bool)'
  end
end

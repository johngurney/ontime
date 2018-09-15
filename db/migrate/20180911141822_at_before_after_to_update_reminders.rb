class AtBeforeAfterToUpdateReminders < ActiveRecord::Migration[5.2]
  def change
    add_column :update_reminders, :before_after, :boolean
  end
end

class AddBesDurFieldToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :bespoke_duration_flag, :boolean
  end
end

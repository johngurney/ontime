class AddDurColToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :duration_in_days, :boolean
  end
end

class AddDurEndDateFieldToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :duration_enddate_flag, :boolean
  end
end

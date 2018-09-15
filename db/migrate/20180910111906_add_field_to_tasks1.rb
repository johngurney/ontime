class AddFieldToTasks1 < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :bespoke_extent_flag, :bespoke_offset_flag
  end
end

class RenameFieldInTasks < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :bespoke_extent_field, :bespoke_extent_flag
  end
end

class RenameTaskIdInTask < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :task_id, :linked_to_task_id
  end
end

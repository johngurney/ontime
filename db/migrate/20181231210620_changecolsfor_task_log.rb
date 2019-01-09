class ChangecolsforTaskLog < ActiveRecord::Migration[5.2]
  def change
    change_column :task_logs, :linked_to_task_id, :string
    rename_column :task_logs, :linked_to_task_id, :linked_to_task
  end
end

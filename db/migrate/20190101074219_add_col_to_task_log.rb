class AddColToTaskLog < ActiveRecord::Migration[5.2]
  def change
    add_column :task_logs, :myuser_id, :integer
  end
end

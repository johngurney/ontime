class AddColToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :template_id, :integer
  end
end

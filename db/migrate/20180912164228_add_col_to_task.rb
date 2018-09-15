class AddColToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :for_template_flag, :boolean
  end
end

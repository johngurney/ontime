class AddFieldToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :bespoke_extent_field, :boolean
  end
end

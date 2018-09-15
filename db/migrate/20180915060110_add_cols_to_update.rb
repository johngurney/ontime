class AddColsToUpdate < ActiveRecord::Migration[5.2]
  def change
    add_column :updates, :completed_flag, :boolean
    add_column :updates, :percentage_completed, :float
  end
end

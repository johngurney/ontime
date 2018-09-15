class AddCols1ToUpdate < ActiveRecord::Migration[5.2]
  def change
    add_column :updates, :percentage_time_passed, :float
  end
end

class AddCol3ToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :offset_in_days, :boolean
  end
end

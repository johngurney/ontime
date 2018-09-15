class AddColToTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :templates, :daily_flag, :boolean
  end
end

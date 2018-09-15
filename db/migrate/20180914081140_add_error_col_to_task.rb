class AddErrorColToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :date_error, :boolean
  end
end

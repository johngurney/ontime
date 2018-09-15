class AddFieldsToMyuser < ActiveRecord::Migration[5.2]
  def change
    add_column :myusers, :has_confirmed_flag, :binary
  end
end

class AddFieldsToMyuser1 < ActiveRecord::Migration[5.2]
  def change
    add_column :myusers, :office, :string
    add_column :myusers, :experience, :string
    add_column :myusers, :team, :string
    add_column :myusers, :position, :string
  end
end

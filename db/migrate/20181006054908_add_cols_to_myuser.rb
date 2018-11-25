class AddColsToMyuser < ActiveRecord::Migration[5.2]
  def change
    add_column :myusers, :work_tel, :string
    add_column :myusers, :mobile_tel, :string
    add_column :myusers, :home_tel, :string
    add_column :myusers, :other_tel1, :string
    add_column :myusers, :mobile_tel2, :string
  end
end

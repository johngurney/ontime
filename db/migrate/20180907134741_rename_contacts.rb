class RenameContacts < ActiveRecord::Migration[5.2]
  def change
    rename_column :contacts, :last_name_, :last_name
  end
end

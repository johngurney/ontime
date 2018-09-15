class RenameContacts1 < ActiveRecord::Migration[5.2]
  def change
    rename_column :contacts, :email_address, :email
  end
end

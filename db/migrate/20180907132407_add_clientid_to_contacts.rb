class AddClientidToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :client_id, :integer
  end
end

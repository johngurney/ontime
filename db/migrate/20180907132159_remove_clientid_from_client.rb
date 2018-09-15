class RemoveClientidFromClient < ActiveRecord::Migration[5.2]
  def change
    remove_column :contacts, :client_id_integer, :string
  end
end

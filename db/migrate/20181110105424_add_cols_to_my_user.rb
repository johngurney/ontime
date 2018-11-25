class AddColsToMyUser < ActiveRecord::Migration[5.2]
  def change
    add_column :myusers, :server_private_key, :text
    add_column :myusers, :client_public_key, :text
    add_column :myusers, :messageroom_id, :integer
  end
end

class CreateClientUserJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :clients_myusers, :id => false do |t|
      t.integer :client_id
      t.integer :myuser_id
      end
  end
end

class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name_
      t.string :client_id_integer
      t.string :telephone_number
      t.string :email_address
      t.string :position
      t.integer :priority
      t.text :comments

      t.timestamps
    end
  end
end

class CreateSupervisers < ActiveRecord::Migration[5.2]
  def change
    create_table :supervisers do |t|
      t.integer :myuser_id
      t.integer :client_id

      t.timestamps
    end
  end
end

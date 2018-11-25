class CreateTempUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :temp_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :position
      t.string :team
      t.string "office"
      t.string "experience"
      t.string "user_status"

      t.timestamps
    end
  end
end

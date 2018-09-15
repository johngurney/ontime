class CreateLoggedOnLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logged_on_logs do |t|
      t.string :token
      t.integer :user
      t.datetime :last_use

      t.timestamps
    end
  end
end

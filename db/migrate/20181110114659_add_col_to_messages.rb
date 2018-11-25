class AddColToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :myuser_id, :integer
  end
end

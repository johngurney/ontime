class AddColColToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :colour, :integer
  end
end

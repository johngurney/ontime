class AddColsToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :number, :integer
  end
end

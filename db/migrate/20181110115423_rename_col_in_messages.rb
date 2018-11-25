class RenameColInMessages < ActiveRecord::Migration[5.2]
  def change
    rename_column :messages, :content, :encrypted_content
  end
end

class RenameColInMessages1 < ActiveRecord::Migration[5.2]
  def change
      rename_column :messages, :chat_id, :forum_name
  end
end

class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :content
      t.string :chat_id
      t.integer :sender_id

      t.timestamps
    end
  end
end

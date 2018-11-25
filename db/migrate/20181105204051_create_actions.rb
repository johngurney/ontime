class CreateActions < ActiveRecord::Migration[5.2]
  def change
    create_table :actions do |t|
      t.text :content
      t.datetime :do_date
      t.integer :message_id
      t.boolean :done

      t.timestamps
    end
  end
end

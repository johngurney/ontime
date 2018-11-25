class CreateJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :actions_myusers, :id => false do |t|
      t.integer :action_id
      t.integer :myuser_id
    end
  end
end

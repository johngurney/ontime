class CreateMyuserTaskJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :myusers, :tasks do |t|
      # t.index [:myuser_id, :task_id]
      # t.index [:task_id, :myuser_id]
    end
  end
end

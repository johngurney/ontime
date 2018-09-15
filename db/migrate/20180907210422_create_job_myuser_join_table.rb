class CreateJobMyuserJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :jobs, :myusers do |t|
      # t.index [:job_id, :myuser_id]
      # t.index [:myuser_id, :job_id]
    end
  end
end

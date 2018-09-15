class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.integer :job_id
      t.integer :task_id
      t.boolean :linked_flag
      t.boolean :start_end_flag
      t.float :offset
      t.float :duration
      t.boolean :completed_flag
      t.float :percentage_completed

      t.timestamps
    end
  end
end

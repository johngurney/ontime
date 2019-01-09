class CreateTaskLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :task_logs do |t|
      t.integer "task_id"
      t.string "comments"
      t.string "name"
      t.datetime "start_date"
      t.datetime "end_date"
      t.integer "linked_to_task_id"
      t.boolean "linked_flag"
      t.boolean "link_to_start"
      t.float "offset"
      t.float "duration"
      t.boolean "fixed_end_date"
      t.boolean "duration_in_days"
      t.boolean "offset_in_days"

      t.timestamps
    end
  end
end

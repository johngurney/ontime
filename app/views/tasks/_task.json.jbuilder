json.extract! task, :id, :name, :start_date, :end_date, :job_id, :task_id, :linked_flag, :start_end_flag, :offset, :duration, :completed_flag, :percentage_completed, :created_at, :updated_at
json.url task_url(task, format: :json)

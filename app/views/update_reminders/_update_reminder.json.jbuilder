json.extract! update_reminder, :id, :type, :proportion, :start_end, :offset, :day_time, :created_at, :updated_at
json.url update_reminder_url(update_reminder, format: :json)

class Update < ApplicationRecord
  belongs_to :task
  belongs_to :myuser

  def created_at_date_stg()
      created_at.strftime("%d %b %Y, %H:%M")
  end

  def new_update(task, myuser, percentage_completed, comments)

    self.myuser = myuser
    self.task = task
    self.completed_flag = task.completed_flag
    self.percentage_completed = percentage_completed
    self.comments = comments
    self.percentage_time_passed = (Time.now - task.start_date) / (task.end_date - task.start_date) * 100

    self.save(validate: false)

  end

end

class TaskLog < ApplicationRecord
  belongs_to :task
  belongs_to :myuser

  def self.new_log(task, comments, myuser)

    log = TaskLog.new

    log.task_id = task.id
    log.comments = comments

    log.name = task.name
    log.start_date = task.start_date
    log.end_date = task.end_date

    if task.linked_flag
      if task.link_to_start
        log.linked_to_task = "Start"
      else
        log.linked_to_task  = Task.find(task.linked_to_task_id).name if task.linked_to_task_id !=0
      end
    end

    log.linked_flag = task.linked_flag
    log.link_to_start = task.link_to_start
    log.offset = task.offset
    log.duration = task.duration
    log.fixed_end_date = task.fixed_end_date
    log.duration_in_days = task.duration_in_days
    log.offset_in_days = task.offset_in_days

    log.myuser = myuser

    log.save(validate: false)
  end

  def changes_to_linking_stg( old_log )
    stg = ""
    stg += "Duration changed from " + old_log.duration.to_s + " day(s) to " + self.duration.to_s + " day(s);" if old_log.duration != self.duration
    stg += "Link changed from: " + link_text(old_log)  + "; to: " + link_text(self) + ";" if (old_log.linked_to_task != self.linked_to_task) || (old_log.linked_to_task != self.linked_to_task) || (old_log.linked_flag != self.linked_flag) || (old_log.link_to_start != self.link_to_start) || (old_log.offset != self.offset) || (old_log.offset_in_days != self.offset_in_days)
    stg
  end

  def duration_text(log)
    log.duration.to_s + (log.duration_in_days ? " day(s)" : " hour(s)")
  end

  def link_text(log)
    if log.linked_flag
      if !log.linked_to_task.blank?
        "linked to " + offset_stg(log) + (log.link_to_start ? "start of " : "end of ") + log.linked_to_task
      else
        ""
      end
    else
      "fixed start date"
    end
  end

  def offset_stg(log)

    if log.offset_in_days
      day_hour = "day(s)"
    else
      day_hour = "hour(s)"
    end

    if log.offset < 0
      log.offset.abs.to_s + " " + day_hour + " before "
    elsif offset > 0
      log.offset.abs.to_s + " " + day_hour + " days after "
    else
      ""
    end

  end

  def changes_to_dates_stg(old_log)
    stg = ""
    stg += "Start date changed from " + old_log.start_date.to_s(:short) + " to " + self.start_date.to_s(:short) + ";" if !old_log.start_date.blank? && !self.start_date.blank? && old_log.start_date != self.start_date
    stg += "End date changed from " + old_log.end_date.to_s(:short) + " to " + self.end_date.to_s(:short) + ";" if !old_log.end_date.blank? && !self.end_date.blank? && old_log.end_date != self.end_date
    stg
  end

end

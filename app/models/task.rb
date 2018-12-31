class Task < ApplicationRecord
  belongs_to :job, optional: true
  belongs_to :template, optional: true
  has_and_belongs_to_many :myusers
  has_many :update_reminders
  has_many :updates



  def start_date_timestg
    self.job.check_if_timezone_exists_and_valid
    if  self.job.daily_flag
      date_stg(self.start_date.in_time_zone(self.job.time_zone))
    else
      date_time_stg(self.start_date.in_time_zone(self.job.time_zone))
    end
  end

  def set_up_new_task

    self.name = "New task"
    self.linked_flag = false
    self.link_to_start = true
    self.offset = 0
    self.duration = 7
    self.completed_flag = false
    self.percentage_completed = 0.0
    self.bespoke_offset_flag = false
    self.bespoke_duration_flag = false
    self.fixed_end_date = false

    self.start_date = Date.today
    self.end_date = Date.today + self.duration.to_i.days

  end

  def end_date_timestg
    self.job.check_if_timezone_exists_and_valid
    if !self.end_date.blank?
      if  self.job.daily_flag
        date_stg(self.end_date.in_time_zone(self.job.time_zone))
      else
        date_time_stg(self.end_date.in_time_zone(self.job.time_zone))
      end
    end
  end

  def date_stg(date_value)
    if date_value.blank?
      ""
    else
      date_value.strftime("%a, %d %b %Y")
    end
  end

  def date_time_stg(date_value)
    if date_value.blank?
      ""
    else
      date_value.strftime("%a, %e %b %Y %H:%M")
    end
  end

  def duration_to_s
    if self.duration.to_i == self.duration
      self.duration.to_i.to_s
    else
      self.duration.to_s
    end
  end

  def parse_date(date_hash)
    if !date_hash.blank?
      Date.new( date_hash["(1i)"].to_i, date_hash["(2i)"].to_i, date_hash["(3i)"].to_i )
    end

  end

  def duration_is_days
    self.job.daily_flag | self.duration_in_days
  end

  def est_progress
    (( Time.now.in_time_zone(self.job.time_zone) - self.start_date.in_time_zone(self.job.time_zone) ) / (self.end_date.in_time_zone(self.job.time_zone) - self.start_date.in_time_zone(self.job.time_zone))).clamp(0,1)
  end

  def task_update_array_entry
    "{task: " + self.id.to_s + ", exp_prog: " + self.est_progress.to_s + ", act_prog:" + (self.percentage_completed / 100).to_s + "}"
  end
end

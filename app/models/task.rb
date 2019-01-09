class Task < ApplicationRecord
  belongs_to :job, optional: true
  belongs_to :template, optional: true
  has_and_belongs_to_many :myusers
  has_many :task_logs
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

  def myuser_can_edit(myuser)
    self.job.client.myuser_is_superviser(myuser) || self.job.myusers.include?(myuser)
  end

  def myuser_can_view(myuser)
    self.myuser_can_edit(myuser) || self.myusers.include?(myuser)
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
    begin
      if !date_hash.blank?
        if self.job.daily_flag
          Date.new( date_hash["(1i)"].to_i, date_hash["(2i)"].to_i, date_hash["(3i)"].to_i )
        else
          DateTime.new( date_hash["(1i)"].to_i, date_hash["(2i)"].to_i, date_hash["(3i)"].to_i, date_hash["(4i)"].to_i, date_hash["(5i)"].to_i,0 )
        end
      end
    rescue
      Date.new(date_hash["(1i)"].to_i, date_hash["(2i)"].to_i, 1 )

    end
  end

  def duration_is_days
    self.job.daily_flag | self.duration_in_days
  end

  def est_progress
    if !self.job.blank? && !self.start_date.blank? && !self.end_date.blank?
      (( Time.now.in_time_zone(self.job.time_zone) - self.start_date.in_time_zone(self.job.time_zone) ) / (self.end_date.in_time_zone(self.job.time_zone) - self.start_date.in_time_zone(self.job.time_zone))).clamp(0,1)
    else
      0
    end
  end

  def task_update_array_entry
    "{task: " + self.id.to_s + ", exp_prog: " + self.est_progress.to_s + ", act_prog:" + (self.percentage_completed / 100).to_s + "}"
  end

  def next_update
    #input info
    #current time; start date of task; end date of task; date of last update


    if Update.where(task_id: self.id).count > 0 && Update.where(task_id: self.id).order(:created_at).last.percentage_completed == 100
      nil
    else
      time_for_reminder = nil
      next_reminder = nil

      self.update_reminders.each do |reminder|
        t = reminder.get_next_reminder_date
        if !t.blank?
          if (time_for_reminder.blank? || t < time_for_reminder) && !(self.updates.count > 0 && self.updates.order(:created_at).last.created_at >= t)
            time_for_reminder = t
            next_reminder = reminder
          end
        end
      end
      puts "***time_for_reminder+++" + time_for_reminder.to_s

      if !time_for_reminder.blank?
        { :date => time_for_reminder , :reminder => next_reminder }
      else
        puts "***nil+++"
        nil
      end
    end
  end

  def next_update_stg
    t = self.next_update
    if t.blank?
      "None"
    else
      t[:date].to_s(:day_date_time_at)
    end
  end

  def link_text
    if self.linked_flag
      if self.linked_to_task_id ==0
        "Linked to: " + self.offset_stg + " start of job"
      elsif Task.where(:id => self.linked_to_task_id).count != 0
        "Linked to: " + self.offset_stg + (self.link_to_start ? "start of: " : "end of: ") + Task.find(self.linked_to_task_id).name
      else
        ""
      end
    else
      "Fixed start date"
    end
  end

  def offset_stg

    if self.offset_in_days
      day_hour = "day(s)"
    else
      day_hour = "hour(s)"
    end

    if self.offset < 0
      self.offset.abs.to_s + " " + day_hour + " before "
    elsif offset > 0
      self.offset.abs.to_s + " " + day_hour + " days after "
    else
      ""
    end

  end

  def duration_text
    if self.fixed_end_date
      "Fixed end date"
    else
     "Duration: " +  self.duration.to_s + (self.duration_in_days ? " day(s)" : " hour(s)")
   end
  end

end

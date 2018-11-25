class UpdateReminder < ApplicationRecord
  belongs_to :task
  belongs_to :reminder_schedule
  has_one :myuser, :through => :tasks

  def reminder_text
    reminder_text1 + (self.allow_email_flag ? ":  Allow emails" :"")
  end

  def reminder_text1

    if self.update_type==0
      "At " + ((self.proportion*100).to_i).to_s + "% through"
    elsif self.update_type==1
       self.offset_days.to_s + " day(s)"  +
          (!self.offset_hours.blank? ?  self.offset_hours  + "hours(s) " : "") +
          (self.before_after ? " before " : " after ") +
          (self.start_end ? "start" : "end")
    elsif self.update_type==2
      lookup={0=>"Sun", 1=>"Mon", 2=>"Tue", 3=>"Wed", 4=>"Thu", 5=>"Fri", 6=>"Sat", }
      "Repeat every "  + lookup[self.repeat_weekday] + " at " + self.repeat_time
    end
  end

  def add_reminder_to_task(task)
    new_reminder=UpdateReminder.new

    new_reminder.update_type = self.update_type
    new_reminder.proportion = self.proportion
    new_reminder.start_end = self.start_end
    new_reminder.offset_days = self.offset_days
    new_reminder.repeat_weekday = self.repeat_weekday
    new_reminder.before_after = self.before_after
    new_reminder.offset_hours = self.offset_hours
    new_reminder.repeat_time = self.repeat_time
    new_reminder.allow_email_flag = self.allow_email_flag
    new_reminder.update_window_percentage_flag = self.update_window_percentage_flag
    new_reminder.update_window_days = self.update_window_days
    new_reminder.update_window_hours = self.update_window_hours
    new_reminder.update_window_percentage = self.update_window_percentage


    new_reminder.task=task
    new_reminder.is_for_task=true

    new_reminder.updated_flag = false

    new_reminder.save(validate: false)

  end


  def set_dates
    task=self.task

    if !task.date_error
      task_length =  task.end_date - task.start_date
      if self.update_type==0    #Proportionate
        self.window_end_date = task.start_date + task_length * self.proportion
      elsif self.update_type==1 #To start or end
        if self.before_after
          m=-1
        else
          m=1
        end

        if self.start_end
          self.window_end_date = task.start_date + self.offset_days.to_i.days * m
        else
          self.window_end_date = task.end_date + self.offset_days.to_i.days * m
        end
        self.window_end_date = task.start_date + ( task.end_date - task.start_date) * self.proportion

      elsif self.update_type==2

      end

      if self.update_window_percentage_flag
        self.window_start_date = self.window_end_date  - task_length * self.update_window_percentage
      else
        self.window_start_date = self.window_end_date  - update_window_days.to_i.days
      end
      self.save(validate:false )
    end

  end
  def start_datestg
    date_stg(self.window_start_date)
  end

  def end_datestg
    date_stg(self.window_end_date)
  end

  def date_stg(date_value)
    if date_value.blank?
      ""
    else
      date_value.strftime("%d %b %Y")
    end
  end

end

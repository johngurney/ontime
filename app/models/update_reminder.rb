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
      "Repeat every "  +
        (self.includes_day?(:monday) ? "Mon; " :"") + \
        (self.includes_day?(:tuesday) ? "Tue; " :"") + \
        (self.includes_day?(:wednesday) ? "Wed; " :"") + \
        (self.includes_day?(:thursday) ? "Thu; " :"") + \
        (self.includes_day?(:friday) ? "Fri; " :"") + \
        (self.includes_day?(:saturday) ? "Sat; " :"") + \
        (self.includes_day?(:sunday) ? "Sun; " :"") #+ \
        #"at " + self.repeat_time
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
    new_reminder.update_window_length = self.update_window_length
    new_reminder.update_window_percentage = self.update_window_percentage


    new_reminder.task=task
    new_reminder.is_for_task=true

    new_reminder.updated_flag = false

    new_reminder.save(validate: false)

  end


  def set_dates

    # #This is called when the timings on a task are updated
    #
    # task=self.task
    #
    # if !task.date_error
    #   task_length =  task.end_date - task.start_date
    #   if self.update_type==0    #Proportionate
    #     self.window_end_date = task.start_date + task_length * self.proportion
    #   elsif self.update_type==1 #To start or end
    #     if self.before_after
    #       m=-1
    #     else
    #       m=1
    #     end
    #
    #     if self.start_end
    #       self.window_end_date = task.start_date + self.offset_days.to_i.days * m
    #     else
    #       self.window_end_date = task.end_date + self.offset_days.to_i.days * m
    #     end
    #     self.window_end_date = task.start_date + ( task.end_date - task.start_date) * self.proportion
    #
    #   elsif self.update_type==2
    #
    #
    #   end
    #
    #   if self.update_window_percentage_flag
    #     self.window_start_date = self.window_end_date  - task_length * self.update_window_percentage
    #   else
    #     self.window_start_date = self.window_end_date  - update_window_days.to_i.days
    #   end
    #   self.save(validate:false )
    # end
  end

  def get_next_reminder_date

    if !self.task.date_error && !self.task.end_date.blank?
      task_length =  self.task.end_date - self.task.start_date
      if self.update_type==0    #Proportionate
        d = self.task.start_date + task_length * self.proportion
        puts "proportion / next_update_date: " + d.to_s
        d

      elsif self.update_type==1 #To start or end
        if self.before_after
          m=-1
        else
          m=1
        end

        if self.start_end
          self.task.start_date + self.offset_days.to_i.days * m
        else
          self.task.end_date + self.offset_days.to_i.days * m
        end

      elsif self.update_type==2


        #time_now = Time.now.in_time_zone(self.task.job.time_zone)
        start_date = self.task.start_date
        if !start_date.blank?
          if self.task.updates.count > 0
            latest_update_date = self.task.updates.maximum(:created_at)
            start_date = latest_update_date if latest_update_date > start_date
          end

          start_date = start_date.beginning_of_day

          puts "repeat / start_date: " + start_date.to_s

          next_update_date = nil
          next_update_date = self.find_next_repeat_date(:monday , start_date, next_update_date)
          next_update_date = self.find_next_repeat_date(:tuesday , start_date, next_update_date)
          next_update_date = self.find_next_repeat_date(:wednesday , start_date, next_update_date)
          next_update_date = self.find_next_repeat_date(:thursday , start_date, next_update_date)
          next_update_date = self.find_next_repeat_date(:friday , start_date, next_update_date)
          next_update_date = self.find_next_repeat_date(:saturday , start_date, next_update_date)
          next_update_date = self.find_next_repeat_date(:sunday , start_date, next_update_date)

          puts "repeat / next_update_date: " + next_update_date.to_s

          if !next_update_date.blank?
            next_update_date + self.repeat_time.seconds_since_midnight
          else
            nil
          end
        end
      end

    end
  end

  def find_next_repeat_date(day, start_date, next_update_date)
    if self.includes_day?(day)
      if next_update_date.blank?
        next_update_date = start_date.next_occurring(day)
      else
        d = start_date.next_occurring(day)
        next_update_date = d if d < next_update_date
      end
    end
    next_update_date
  end




  def find_prev_recurring_update(date_time)

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

  def includes_day?(day)
    case day
      when :monday
        self.repeat_weekday & 0b0000001 != 0

      when :tuesday
        self.repeat_weekday & 0b0000010 != 0

      when :wednesday
        self.repeat_weekday & 0b0000100 != 0

      when :thursday
        self.repeat_weekday & 0b0001000 != 0

      when :friday
        self.repeat_weekday & 0b0010000 != 0

      when :saturday
        self.repeat_weekday & 0b0100000 != 0

      when :sunday
        self.repeat_weekday & 0b1000000 != 0
      else
        false
    end

  end

  def repeat_time_check
    if self.repeat_time.blank?
      ActiveSupport::TimeZone[self.task.job.time_zone].parse(Rails.configuration.working_day_start_time)
      #0
    else
      self.repeat_time
    end
  end

  def due_period
    if self.update_window_percentage_flag
      if !self.task.date_error && !self.task.start_date.blank?  && !self.task.end_date.blank?
         ((self.task.end_date - self.task.start_date) * self.update_window_percentage ).to_i
       else
         0
       end
    else
      self.update_window_length_in_seconds
    end

  end


end

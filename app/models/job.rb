class Job < ApplicationRecord
  belongs_to :client
  has_many :tasks
  has_and_belongs_to_many :myusers

  @circular_flags={}
  @done_flags={}



  def update_timings
    check_if_timezone_exists_and_valid
    @done_flags={}

    self.tasks.each do |task|
      task.date_error=false
      task.save(validate: false)
    end

    self.tasks.each do |task|
      @circular_flags={}
      get_start_date_of_task(task)
      puts "***" + task.start_date.to_s
      puts "***" + task.duration.to_s
      puts "***" + task.end_date.to_s
    end

    self.end = self.start

    self.tasks.each do |task|
      task.update_reminders.each do |reminder|
        reminder.set_dates
      end
     if !task.end_date.blank?
       if task.end_date > self.end
         self.end=task.end_date
       end
     end
    end

  end

  def local_date_time(t)
    check_if_timezone_exists_and_valid
    t.in_time_zone(self.time_zone)
  end

  def end_datestg
    date_stg(self.end)
  end

  def date_stg(date_value)
    if date_value.blank?
      ""
    else
      date_value.strftime("%d %b %Y")
    end
  end

  def working_hours_between( start_date_and_time, end_date_and_time )
    check_if_timezone_exists_and_valid
    current_date = get_date_part(start_date_and_time)
    working_time_total = 0

    start_of_day_seconds = seconds_in_day(self.working_day_start)
    end_of_day_seconds = seconds_in_day(self.working_day_end)

    while current_date <= get_date_part(end_date_and_time) do
      if !is_weekend(current_date) or self.include_weekends
        if current_date != get_date_part(start_date_and_time)
          s=start_of_day_seconds
        else
          s=seconds_in_day(start_date_and_time)
        end

        if current_date != get_date_part(end_date_and_time)
          e = end_of_day_seconds
        else
          e = seconds_in_day(end_date_and_time)
        end
        working_time_total += (e - s)
      end

      current_date+= 1.day

    end
    working_time_total / 3600
  end

  def start_date
    d= self.start.strftime("%d %b %Y")
  end

  def end_date
    d= self.end.strftime("%d %b %Y")
  end

  def date123
    check_if_timezone_exists_and_valid
    puts "****" + self.time_zone.to_s
    ActiveSupport::TimeZone[self.time_zone].parse("8 Oct 2018 11:00")
  end

  def check_if_timezone_exists_and_valid
    if self.time_zone.blank? or ActiveSupport::TimeZone[self.time_zone].present?
      self.time_zone =  Rails.configuration.default_time_zone
      self.save
    end
  end

  private

  def move_to_prev_working_day(start_date, working_day_end_time_hour=nil)
    date_in_zone=start_date.in_time_zone(self.time_zone)
    if (!self.include_weekends) && is_weekend(date_in_zone)
      if !working_day_end_time_hour.blank?
        set_hour_of_date(date_in_zone.prev_occurring(:friday), working_day_end_time_hour)
      else
        date_in_zone.prev_occurring(:friday)
      end
    else
      start_date
    end
  end


  def move_to_next_working_day(start_date, working_day_start_time_hour=nil)
    date_in_zone=start_date.in_time_zone(self.time_zone)
    if (!self.include_weekends) && is_weekend(date_in_zone)
      if !working_day_start_time_hour.blank?
        set_hour_of_date(date_in_zone.next_occurring(:monday), working_day_start_time_hour)
      else
        date_in_zone.next_occurring(:monday)
      end
    else
      start_date
    end
  end

  def get_start_date_of_task(task)
    if @done_flags[task.id]
      task.start_date
    else
      if !@circular_flags[task.id]
        @circular_flags[task.id]=true

        if !task.linked_flag
          puts "*** 1 ***"
          if !task.fixed_end_date
            puts "*** 2 ***"
            puts "start date " + task.start_date.to_s
            puts "duration " + task.duration.to_s
            task.end_date = add_duration_to_date(task.start_date , task.duration)
            puts task.end_date.to_s
            task.save(validate: false)
          end
          @done_flags[task.id]=true
          task.start_date
        else
          if task.linked_to_task_id.blank? or task.linked_to_task_id.blank? or task.linked_to_task_id==0
            task.start_date = add_subtract_duration_to_date(self.start ,  task.offset)
          else

            linked_to_task=Task.find(task.linked_to_task_id)
            start_of_linked_to_task=get_start_date_of_task(linked_to_task)

            if !start_of_linked_to_task.blank?
              if task.link_to_start
                task.start_date = add_subtract_duration_to_date(start_of_linked_to_task ,  task.offset)
              else
                task.start_date = add_subtract_duration_to_date(linked_to_task.end_date ,  task.offset)
              end
            else
              task.date_error = true
              task.save(validate: false)
            end


          end

          if !task.date_error
            if !task.fixed_end_date
              task.end_date= add_duration_to_date( task.start_date , task.duration)
            end

            task.save(validate: false)
            @done_flags[task.id]=true

            task.start_date
          end
        end
      else
        task.date_error = true
        task.save
      end
    end


  end

  def add_subtract_duration_to_date(start_date, duration)
    if duration > 0
      add_duration_to_date(start_date, duration)
    elsif duration < 0
      subtract_duration_from_date(start_date, -duration)
    else
      start_date
    end
  end


  def add_duration_to_date(start_date, duration)

    if self.include_weekends
      working_days_per_week=7
    else
      working_days_per_week=5
    end
    if self.daily_flag
      if self.include_weekends
        #RETURN
        start_date + duration
      else
        #RETURN
        start_date + ((duration.div working_days_per_week) * 7 + (duration.modulo working_days_per_week)).days
      end
    else

      start_time_hour=self.working_day_start.in_time_zone(self.time_zone).hour
      end_time_hour=self.working_day_end.in_time_zone(self.time_zone).hour
      working_day_length_hours = end_time_hour - start_time_hour
      weeks_duration = (duration.div (working_day_length_hours * working_days_per_week))
      duration-= (weeks_duration * working_day_length_hours * working_days_per_week )
      current_date = start_date.in_time_zone(self.time_zone) + (weeks_duration* 7).days
      current_date = move_to_next_working_day(current_date, start_time_hour)

      while (duration + current_date.hour) > end_time_hour
        duration-=  ( end_time_hour-current_date.hour )
        current_date += 1.days
        current_date = move_to_next_working_day(current_date, start_time_hour)
        current_date = set_hour_of_date( current_date , start_time_hour)
      end

      #RETURN
      set_hour_of_date( current_date , current_date.hour + duration)

    end
  end


  def subtract_duration_from_date(start_date, duration)
    if self.include_weekends
      working_days_per_week=7
    else
      working_days_per_week=5
    end
    if self.daily_flag
      if self.include_weekends
        #RETURN
        start_date - duration
      else
        #RETURN
        start_date - ((duration.div working_days_per_week) * 7 + (duration.modulo working_days_per_week))
      end
    else

      start_time_hour=self.working_day_start.in_time_zone(self.time_zone).hour
      end_time_hour=self.working_day_end.in_time_zone(self.time_zone).hour
      working_day_length_hours = end_time_hour - start_time_hour
      weeks_duration = (duration.div (working_day_length_hours * working_days_per_week))
      duration-= (weeks_duration * working_day_length_hours * working_days_per_week )
      current_date = start_date.in_time_zone(self.time_zone) - (weeks_duration * 7).days
      current_date = move_to_prev_working_day(current_date, end_time_hour)

      while (current_date.hour-duration ) < start_time_hour
        duration-=  ( current_date.hour - start_time_hour )
        current_date -= 1.days
        current_date = move_to_prev_working_day(current_date, end_time_hour)
        current_date = set_hour_of_date( current_date , end_time_hour)
      end

      #RETURN
      set_hour_of_date( current_date , current_date.hour - duration)

    end
  end


  def find_fractional_hour(date)
    check_if_timezone_exists_and_valid
    date_in_zone=date.in_time_zone(self.time_zone)
    date_in_zone.hour.to_f + date_in_zone.min.to_f / 60
  end

  def set_hour_of_date(date, hour)
    check_if_timezone_exists_and_valid
    date_in_zone=date.in_time_zone(self.time_zone)
    date_in_zone - (date_in_zone.hour.hours + date_in_zone.min.minutes) + hour.hours
  end

  def is_weekend(test_date)
    test_date.saturday? or test_date.sunday?
  end

  def seconds_in_day(test_datetime)
    test_datetime.hour * 3600 + test_datetime.min * 60
  end

  def get_date_part(datetime)
    datetime - seconds_in_day(datetime)
  end



end

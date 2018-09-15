class Job < ApplicationRecord
  belongs_to :client
  has_many :tasks
  has_and_belongs_to_many :myusers

  @circular_flags={}
  @done_flags={}

  def UpdateTimings
    @done_flags={}

    self.tasks.each do |task|
      task.date_error=false
      task.save(validate: false)
    end

    self.tasks.each do |task|
      @circular_flags={}
      GetStartDateOfTask(task)
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

  private

  def GetStartDateOfTask(task)
    if @done_flags[task.id]
      task.start_date
    else
      if !@circular_flags[task.id]
        @circular_flags[task.id]=true

        if !task.linked_flag
          if !task.fixed_end_date
            task.end_date=task.start_date + task.duration.to_i.days
            task.save(validate: false)
          end
          @done_flags[task.id]=true
          task.start_date
        else
          if task.linked_to_task_id.blank? or task.linked_to_task_id.blank? or task.linked_to_task_id==0
            task.start_date = self.start + task.offset.to_i.days
          else

            linked_to_task=Task.find(task.linked_to_task_id)
            d=GetStartDateOfTask(linked_to_task)

            if !d.blank?
              if task.link_to_start
                task.start_date= d + task.offset.to_i.days
              else
                task.start_date = linked_to_task.end_date + task.offset.to_i.days
              end
            else
              task.date_error = true
              task.save(validate: false)
            end


          end

          if !task.date_error
            if !task.fixed_end_date
              task.end_date=task.start_date + task.duration.to_i.days
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
end

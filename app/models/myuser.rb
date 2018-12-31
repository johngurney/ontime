class Myuser < ApplicationRecord
  has_and_belongs_to_many :clients
  has_and_belongs_to_many :jobs
  has_and_belongs_to_many :tasks
  has_many :update_reminders, :through => :tasks
  has_many :updates
  has_and_belongs_to_many :actions

  def confirmation_sent_at_string
    date_stg self.confirmation_sent_at
  end

  def date_stg(date_value)
    if date_value.blank?
      ""
    else
      date_value.strftime("%e %b %Y at %H:%M")
    end
  end

  def name
    self.first_name + " " + self.last_name
  end

  def add_new_user_options
    if self.user_status == Rails.configuration.super_admin_name
      [Rails.configuration.super_admin_name , Rails.configuration.admin_name, Rails.configuration.user_name, Rails.configuration.client_name]
    elsif self.user_status == Rails.configuration.admin_name
      [Rails.configuration.user_name, Rails.configuration.client_name]
    end
  end

  def is_admin?
    user_status == Rails.configuration.super_admin_name ||  user_status == Rails.configuration.admin_name
  end

  def message_forums
    forums = []
    Message.select(:forum_name).distinct.each do |message|
      puts "*!*" + message.forum_name
      myusers = message.find_myusers_for_forum()
      if !myusers.blank? and myusers.include?(self)
        max_date = Message.where("forum_name=?", message.forum_name).maximum(:created_at)
        forums << Message.where("forum_name=? AND created_at=?", message.forum_name, max_date).first
      end
    end
    puts forums
    forums.sort {|x,y| -(x.created_at <=> y.created_at)}
    # forums
    # puts forums
  end

  def tasks_for_myuser

    _tasks = []

    if show_tasks_by_task
      self.tasks.each do |task|
        if Hide.where(:myuser_id => self.id, :element => "task" + task.id.to_s).count == 0
          _tasks << task
        end
      end
    end

    if show_tasks_by_job
      self.jobs.each do |job|
        job.tasks.each do |task|
          if !_tasks.include? task
            if Hide.where(:myuser_id => self.id, :element => "task" + task.id.to_s).count == 0
              _tasks << task
            end
          end
        end
      end
    end

    if show_tasks_by_client
      self.clients.each do |client|
        client.jobs.each do |job|
          job.tasks.each do |task|
            if !_tasks.include? task
              if Hide.where(:myuser_id => self.id, :element => "task" + task.id.to_s).count == 0
                _tasks << task
              end
            end
          end
        end
      end
    end

    case self.order_tasks_field
      when "client"
        _tasks.sort {|x,y| (x.job.client.name <=> y.job.client.name)}
      when "client_reverse"
        _tasks.sort {|x,y| -(x.job.client.name <=> y.job.client.name)}
      when "job"
        _tasks.sort {|x,y| (x.job.name <=> y.job.name)}
      when "task_reverse"
        _tasks.sort {|x,y| -(x.job.name <=> y.job.name)}
      when "task"
        _tasks.sort {|x,y| (x.name <=> y.name)}
      when "task_reverse"
        _tasks.sort {|x,y| -(x.name <=> y.name)}
      when "start_date"
        _tasks.sort {|x,y| (x.start_date.to_i <=> y.start_date.to_i)}
      when "start_date_reverse"
        _tasks.sort {|x,y| -(x.start_date.to_i <=> y.start_date.to_i)}
      when "end_date"
        _tasks.sort {|x,y| ( x.end_date.to_i <=> y.end_date.to_i ) }
      when "end_date_reverse"
        _tasks.sort {|x,y| -( x.end_date.to_i <=> y.end_date.to_i ) }
      when "progress"
        _tasks.sort {|x,y| ( x.task.percentage_completed - x.est_progress * 100 <=> y.task.percentage_completed - y.est_progress * 100 ) }
      when "progress_reverse"
        _tasks.sort {|x,y| -( x.task.percentage_completed - x.est_progress * 100 <=> y.task.percentage_completed - y.est_progress * 100 ) }

      else
        _tasks.sort {|x,y| (x.created_at <=> y.created_at)}
    end

  end

  def jobs_for_myuser

    _jobs = []

    if self.show_jobs_by_job
      self.jobs.each do |job|
        if Hide.where(:myuser_id => self.id, :element => "job"+job.id.to_s).count == 0
          _jobs << job
        end
      end
    end

    if self.show_jobs_by_client
      self.clients.each do |client|
        client.jobs.each do |job|
          if !_jobs.include? job
            if Hide.where(:myuser_id => self.id, :element => "job"+job.id.to_s).count == 0
              _jobs << job
            end
          end
        end
      end
    end

    case self.order_jobs_field
      when "client"
        _jobs.sort {|x,y| (x.client.name <=> y.client.name)}
      when "client_reverse"
        _jobs.sort {|x,y| -(x.client.name <=> y.client.name)}
      when "job"
        _jobs.sort {|x,y| (x.name <=> y.name)}
      when "job_reverse"
        _jobs.sort {|x,y| -(x.name <=> y.name)}
      when "start_date"
        _jobs.sort {|x,y| (x.start_date.to_i <=> y.start_date.to_i)}
      when "start_date_reverse"
        _jobs.sort {|x,y| -(x.start_date.to_i <=> y.start_date.to_i)}
      when "end_date"
        _jobs.sort {|x,y| ( x.end_date.to_i <=> y.end_date.to_i ) }
      when "end_date_reverse"
        _jobs.sort {|x,y| -( x.end_date.to_i <=> y.end_date.to_i ) }
      when "progress"
        _jobs.sort {|x,y| ( x.on_schedule ? 1 : 0 <=> y.on_schedule ? 1 : 0 ) }
      when "progress_reverse"
        _jobs.sort {|x,y| -( x.on_schedule ? 1 : 0 <=> y.on_schedule ? 1 : 0 ) }

      else
        _jobs.sort {|x,y| (x.created_at <=> y.created_at)}
    end

  end


  def task_update_array

    if self.tasks.count > 0
      stg ="[ "
      flag = false
      self.tasks.each do |task|
        if flag == true
          stg += ", "
        else
          flag = true
        end
        stg += task.task_update_array_entry
      end
      stg += " ]"
      stg
    else
      ""
    end
  end

end

  class JobsController < ApplicationController

    before_action :get_job, only: [:amend_team, :timing, :today, :show, :now, :edit, :update, :import_template, :delete_all_tasks, :message_forum]



  def index_for_client
    get_client
    client_id = @client.id
    @jobs = Job.where(:client => client_id)
    render 'index'
  end

  def new_job_for_client

    @job= Job.new
    @job.set_up_new_job
    get_client
    @job.client=@client
    @job.save

    setup_for_edit
    render 'edit'
  end



  def create
    @job = Job.new (job_params)
    @job.set_up_new_job
    @job.name = params[:name]
    client=Client.find(@job.client_id)
    if @job.save
      redirect_to client_path(client)
    else
      redirect_to client_path(client)
    end
  end

  def amend_team
  end

  def add_users
    job= Job.find(params[:jobid])
    myusers = Myuser.all
    myusers.each do |myuser|
      s = params['check'+myuser.id.to_s]
      if !s.blank?
        job.myusers << myuser
      end
    end
    job.save
    redirect_to edit_job_path(job)
  end

  def remove_users
    job= Job.find(params[:jobid])
    myusers = Myuser.all
    myusers.each do |myuser|
      s = params['check'+myuser.id.to_s]
      if !s.blank?
        job.myusers.delete(myuser)
      end
    end
    job.save
    redirect_to edit_job_path(job)
  end

  def timing

    time_zone = params[:time_zone]

    if !time_zone.blank?
      @job.daily_flag = (params[:daily_option] == "1")

      @job.time_zone=time_zone

      d1 = params[:start]

      if @job.daily_flag
        time_start_string = d1["(1i)"] + "/" + d1["(2i)"] + "/" + d1["(3i)"]
        @job.start = ActiveSupport::TimeZone[time_zone].parse(time_start_string)
      else
        d2 = params[:start_time]

        if !d2.blank?
          time_start_string = d1["(1i)"] + "/" + d1["(2i)"] + "/" + d1["(3i)"] + " " +  d2["(4i)"] + ":" + d2["(5i)"]
          @job.start = ActiveSupport::TimeZone[time_zone].parse(time_start_string)
        else
          time_start_string = d1["(1i)"] + "/" + d1["(2i)"] + "/" + d1["(3i)"] + " " +  Rails.configuration.working_day_start_time
          @job.start = ActiveSupport::TimeZone[time_zone].parse(time_start_string)
        end

        d=params[:working_day_start]
        if !d.blank?
          working_day_start_string = d["(4i)"] + ":" + d["(5i)"]
          @job.working_day_start = ActiveSupport::TimeZone[time_zone].parse(working_day_start_string)
        else
          @job.working_day_start = ActiveSupport::TimeZone[time_zone].parse(Rails.configuration.working_day_start_time)
        end

        d=params[:working_day_end]
        if !d.blank?
          working_day_end_string = d["(4i)"] + ":" + d["(5i)"]
          @job.working_day_end = ActiveSupport::TimeZone[time_zone].parse(working_day_end_string)
        else
          @job.working_day_end = ActiveSupport::TimeZone[time_zone].parse(Rails.configuration.working_day_end_time)
        end
      end

      @job.include_weekends = (params[:inc_weekends]=="1")



      @job.save

    end

    redirect_to edit_job_path(@job)

  end

  def show

  end

  def today
    if @job.daily_flag
      @job.start = Date.today
    else
      @job.start = Date.today + @job.start.hour*3600 + @job.start.min*60
    end
    @job.save
    redirect_to edit_job_path(@job)
  end

  def now
    if !@job.daily_flag
      @job.start = Time.now.in_time_zone(@job.time_zone)

      @job.save
    end
    redirect_to edit_job_path(@job)
  end

  def setup_for_edit
    @templates=[]
    Template.all.each do |template|
      @templates<< [template.name ,template.id ]
    end

  end

  def edit
    @job.update_timings
    setup_for_edit

  end

  def delete_task
    get_task
    @job=@task.job
    @task.delete
    @job.update_timings
    setup_for_edit
    render 'edit'

  end

  def update
    @job.update(job_params)

    redirect_to edit_job_path (@job)

  end

  def import_template
    template=Template.find(params[:template])

    lookup={}
    template.tasks.each do |task|

      new_task=Task.new
      new_task.set_up_new_task
      new_task.name=task.name
      new_task.linked_to_task_id=task.linked_to_task_id
      if new_task.linked_to_task_id.blank?
        new_task.linked_to_task_id=0
      end

      new_task.linked_flag=task.linked_flag

      new_task.offset=task.offset
      new_task.link_to_start=task.link_to_start


      new_task.bespoke_offset_flag=task.bespoke_offset_flag
      new_task.bespoke_duration_flag=task.bespoke_duration_flag
      new_task.fixed_end_date=task.fixed_end_date
      new_task.duration=task.duration

      new_task.completed_flag=false
      new_task.percentage_completed=0

      new_task.for_template_flag=false

      new_task.job = @job

      task.update_reminders.each do |reminder|
        reminder.add_reminder_to_task(new_task)
      end

      @job.myusers.each do |myuser|
        new_task.myusers << myuser
      end

      new_task.save(validate: false)

      lookup[task.id]=new_task.id
    end

    lookup.each do |old_id, new_id|
      task = Task.find(new_id)
      if task.linked_flag
        new_linked_id=lookup[task.linked_to_task_id]
        if !new_linked_id.blank?
          task.linked_to_task_id = new_linked_id
          task.save(validate: false)
        end
      end
    end

    @job.update_timings

    redirect_to edit_job_path (@job)
  end


  def delete_all_tasks

    @job.tasks.delete_all


    @job.update_timings

    redirect_to edit_job_path (@job)
  end

  def message_forum
    @message_forum_name = "job" + @job.id.to_s
    @is_task = false
    @myusers_for_message_forum = @job.myusers
    render "tasks/message_forum", :layout => "message_forum"
  end


  def summons_email1

    @job.myusers.each do |myuser|
      if params["check" + myuser.id.to_s] == "1"
        UserMailer.summons_email(params[:email_message],  myuser, @job, request.base_url.to_s).deliver_now
      end
    end

    @is_task = false
    render "summons_email_sent", :layout => "message_forum"


  end

  def summons_landing

  end

  private

  def get_job
    @job = Job.find(params[:id])
    puts "****** job_id" + @job.id.to_s
  end

  def get_task
    @task= Task.find(params[:taskid])
  end

  def get_client
    @client = Client.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:name, :comment)
  end

end

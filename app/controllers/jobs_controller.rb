  class JobsController < ApplicationController

  def index_for_client
    find_client
    client_id = @client.id
    @jobs = Job.where(:client => client_id)
    render 'index'
  end

  def new_job_for_client
    @job= Job.new
    find_client
    @client=Client.find(params[:id])
    @job.client=@client
    @job.name="New job"
    @job.start=DateTime.now
    @job.daily_flag=true
    @job.save

    setup_for_edit
    render 'edit'
  end



  def create
    @job= Job.new (job_params)
    client=Client.find(@job.client_id)
    if @job.save
      redirect_to client_path(client)
    else
      redirect_to client_path(client)
    end
  end

  def amend_team
    find_job
    @client = @job.client
    @jobmyusers = @job.myusers
    @clientmyusers = @client.myusers
    @myusers = Myuser.all
    puts "###"+@myusers.count.to_s
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
    find_job
    @job.daily_flag = (params[:daily_option] == "1")
    d = params[:start]
    @job.start = Date.new(d["(1i)"].to_i,d["(2i)"].to_i,d["(3i)"].to_i)
    @job.save
    redirect_to edit_job_path(@job)

  end

  def today
    find_job
    @job.start = Date.today()
    puts "+++" + @job.start.to_s
    @job.save
    redirect_to edit_job_path(@job)

  end

  def setup_for_edit
    @templates=[]
    Template.all.each do |template|
      @templates<< [template.name ,template.id ]
    end

  end

  def edit
    puts "&&&"
    find_job
    @job.UpdateTimings
    @client=@job.client
    puts "%%%" + @job.name + "; " + @client.name
    @tasks = @job.tasks
    @jobmyusers=@job.myusers
    @clientmyusers=@client.myusers
    setup_for_edit

  end

  def delete_task
    find_task
    @job=@task.job
    @task.delete
    @job.UpdateTimings
    @client=@job.client
    @tasks = @job.tasks
    @jobmyusers=@job.myusers
    @clientmyusers=@client.myusers
    setup_for_edit
    render 'edit'

  end

  def update
    find_job
    @job.update(job_params)

    redirect_to edit_job_path (@job)

  end

  def import_template
    find_job
    template=Template.find(params[:template])

    lookup={}
    template.tasks.each do |task|

      new_task=Task.new
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
          puts "***" + old_id.to_s + "; " + new_id.to_s + "; " + new_linked_id.to_s
          task.save(validate: false)
        end
      end
    end

    @job.UpdateTimings

    redirect_to edit_job_path (@job)
  end


  def delete_all_tasks
    find_job
    @job.tasks.delete_all


    @job.UpdateTimings

    redirect_to edit_job_path (@job)
  end

  private

  def find_job
    @job = Job.find(params[:id])
  end

  def find_task
    @task= Task.find(params[:taskid])
  end

  def find_client
    @client = Client.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:name, :comment)
  end

end

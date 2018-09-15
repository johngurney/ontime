class TasksController < ApplicationController

  before_action :set_task, only: [:show, :edit, :update, :reminders_completed]

  def new_task_for_job
    setup_task
    set_job
    puts "***" + @job.id.to_s
    @task.job = @job
    @task.template = Template.first
    @task.save

    @client=@job.client
    edit_set_up_for_selectors
    render 'edit'
  end

  def new_task_for_template
    setup_task
    set_template
    @task.job = Job.first
    @task.template=@template
    @task.for_template_flag = true
    @task.save
    edit_set_up_for_selectors
    render 'edit_for_template'
  end

  def setup_task
    @task= Task.new
    @task.name="New task"
    @task.linked_flag=false
    @task.link_to_start=true
    @task.offset=0
    @task.duration=7
    @task.completed_flag=false
    @task.percentage_completed=0.0
    @task.bespoke_offset_flag=false
    @task.bespoke_duration_flag=false
    @task.fixed_end_date=false

    @task.start_date=Date.today
    @task.end_date=Date.today + @task.duration.to_i.days

    puts "&&& " + @task.start_datestg + "; " + @task.end_datestg + "; " + @task.duration.to_s

  end

  # GET /tasks/1/edit
  def edit


    edit_set_up_for_selectors

    if !@task.for_template_flag

     @job=@task.job
      @client=@job.client
      @taskmyusers = @task.myusers
      @jobmyusers=@job.myusers

     @job.tasks.each  do |task|
       if task.id != @task.id
         @tasks_to_link_to << [task.name , task.id]
       end
     end

     render 'edit'

    else
      @template=@task.template
      @template.tasks.each  do |task|
        if task.id != @task.id
          @tasks_to_link_to << [task.name , task.id]
        end
      end
      render 'edit_for_template'

    end
  end


  def edit_set_up_for_selectors
    @offset_options=[-28, -14, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 10, 14, 28, "Specify"]
    @offset_options_hours=[]
    @duration_options=[0, 1, 2, 3, 4, 5, 6, 7, 10, 14, 28, "Specify"]
    @progress=[]
    @duration_options_hours=[]
    (-47..47).each do |a|

      b=(a.to_f/48).round(3)

      @offset_options_hours  << [offset_duration_hours_value(b), b ]
      if a>= 0
        @duration_options_hours << [offset_duration_hours_value(b), b ]

      end

    end

    (0..10).each do |a|
      @progress << (a * 10).to_s # + '%'
    end

    @tasks_to_link_to=[]
    @tasks_to_link_to << ["Start", 0]

    @schedules=[]
    ReminderSchedule.all.each do |schedule|
      @schedules<< [schedule.name ,schedule.id ]
    end

  end

  def import_schedule

    set_task
    schedule = ReminderSchedule.find(params[:schedule])

    schedule.update_reminders.each do |reminder|
      reminder.add_reminder_to_task(@Task)
    end
    redirect_to edit_task_path(@task)
  end


  def timing

    set_task

    if @task.linked_flag

      @task.link_to_start = params[:start_end] == "1"
      @task.linked_to_task_id=params[:linked_to_task].to_i

      offset = params[:offset_days_select]
      if !offset.blank?
        if offset == "Specify"
          @task.bespoke_offset_flag = true
          if !params[:offset_days_text].blank?
            @task.offset = params[:offset_days_text]
          end
        else
          @task.bespoke_offset_flag = false
          @task.offset = offset.to_i
        end
      end
    else

      @task.start_date = @task.parse_date(params[:start_date])

    end

    @task.fixed_end_date = (params[:duration] == "1")
    if !@task.fixed_end_date

      duration = params[:duration_days_select]
      if !duration.blank?
        if duration== "Specify"
          @task.bespoke_duration_flag = true
          if !params[:duration_days_text].blank?
            @task.duration = params[:duration_days_text]
          end
        else
          @task.bespoke_duration_flag = false
          @task.duration = params[:duration_days_select].to_i
        end
      end

      duration_hours = params[:duration_hours]
      if !duration_hours.blank?
        @task.duration += duration_hours.to_f
      end
    else

      @task.end_date = @task.parse_date(params[:end_date])

    end


    @task.save(validate: false)

    @task.job.UpdateTimings
    redirect_to edit_task_path(@task)

  end



  def progress
    task = Task.find(params[:id])
    task.percentage_completed= params[:progress].to_i
    redirect_to edit_task_path(task)
  end

  def add_users
    task= Task.find(params[:id])
    myusers = Myuser.all
    myusers.each do |myuser|
      s = params['check'+myuser.id.to_s]
      if !s.blank?
        task.myusers << myuser
      end
    end
    task.save
    redirect_to edit_task_path(task)
  end

  def linked
    task = Task.find(params[:id])
    task.linked_flag = (params[:linked]) == "1"
    task.save(validate: false)
    task.job. UpdateTimings
    redirect_to edit_task_path(task)
  end

  def remove_users
    task= Task.find(params[:id])
    puts "&&&" + task.id.to_s + "; " + task.for_template_flag.to_s
    myusers = Myuser.all
    myusers.each do |myuser|
      s = params['check'+myuser.id.to_s]
      if !s.blank?
        task.myusers.delete(myuser)
      end
    end
    task.save
    redirect_to edit_task_path(task)
  end


  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    job = @task.job
    puts "***" + job.name
    if @task.save
      redirect_to job_path(job)
    else
      redirect_to job_path(job)
    end

  end

  def update
    @task.update(task_params)
    redirect_to edit_task_path(@task)

  end

  def reminders_completed
    @task.update_reminders.each  do |reminder|
      reminder.updated_flag = params["updated" +  reminder.id.to_s] == "1"
      reminder.save
    end
    redirect_to edit_task_path(@task)

  end

  def delete_reminder
    reminder=UpdateReminder.find(params[:id])
    task=reminder.task
    reminder.destroy
    redirect_to edit_task_path(task)

  end


  def offset_days_value(task)
    if task.bespoke_offset_flag
      "Specify"
    else
      task.offset.to_i
    end
  end

  def duration_days_value(task)
    if task.bespoke_duration_flag
      "Specify"
    else
      puts "!!" + task.duration.to_s
      task.duration.to_i
    end
  end

  def offset_duration_hours_value(value)
    f=false
    value = value.modulo(1).round(3)
    if value < 0
      value= - value
      f=true
    end
    v=Time.at(value * 3600 * 24+0.5).strftime("%H:%M")
    if f
      "-" + v
    else
      v
    end
  end


  helper_method :offset_days_value, :offset_duration_hours_value, :duration_days_value


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

  def set_job
    @job= Job.find(params[:jobid])
  end

  def set_template
    @template = Template.find(params[:templateid])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name )
    end
end

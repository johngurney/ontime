class TasksController < ApplicationController

  before_action :get_task, only: [:show, :edit, :edit1, :update, :reminders_completed, :timing, :import_schedule, :message_forum, :summons_landing, :summons_email]
  skip_before_action :verify_authenticity_token, only: [:action]

  def new_task_for_job

    setup_task
    set_job
    @task.job = @job
    if Template.count > 0
      @task.template = Template.first
    end

    @task.save(validate: false)


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
    @task.save(validate: false)
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

  end

  # GET /tasks/1/edit
  def edit

    edit_set_up_for_selectors
    if @duration_options.include? @task.duration
      @task.bespoke_duration_flag = false
    end

    if !@task.for_template_flag
      edit_set_up_links
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

  #Window.open
  #https://www.w3schools.com/jsref/met_win_open.asp

  def edit1
    #This is used on timing so that there is not the bepokse flag check

    edit_set_up_for_selectors
    edit_set_up_links
    render 'edit'

  end

  def edit_set_up_for_selectors
    if @task.offset_in_days
      @offset_options=[-28, -14, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 10, 14, 28, "Specify"]
    else
      @offset_options=[]
      (-47..47).each do |a|

        @offset_options  <<  a.to_f / 2
      end
      @offset_options << ["Specify"]
    end

    if @task.duration_is_days
      @duration_options=[]
      [0, 1, 2, 3, 4, 5, 6, 7, 10, 14, 28].each do |a|
        @duration_options << duration_days_stg(a)
      end
    else
      @duration_options=[]
      (0..20).each do |a|
        @duration_options << duration_hours_stg(a.to_f/2)
      end
      (11..20).each do |a|
        @duration_options << duration_hours_stg(a)
      end
      (5..10).each do |a|
        @duration_options << duration_hours_stg(a * 5)
      end
      (6..10).each do |a|
        @duration_options << (a * 10)
      end
    end
    @duration_options << ["Specify"]

    @progress=[]
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

  def edit_set_up_links
    @task.job.tasks.each  do |task|
      if task.id != @task.id
        @tasks_to_link_to << [task.name , task.id]
      end
    end
  end

  def import_schedule

    schedule = ReminderSchedule.find(params[:schedule])

    schedule.update_reminders.each do |reminder|
      reminder.add_reminder_to_task(@Task)
    end
    redirect_to edit_task_path(@task)
  end


  def timing

    if @task.linked_flag

      @task.link_to_start = params[:start_end] == "1"
      @task.linked_to_task_id=params[:linked_to_task].to_i

      @task.offset_in_days = (params[:offset_days_hours] == "Days")

      offset = params[:offset_period_select]
      if !offset.blank?
        if offset == "Specify"
          @task.bespoke_offset_flag = true
          if !params[:offset_bespoke_period].blank?
            @task.offset = params[:offset_bespoke_period].to_f
          end
        else
          @task.bespoke_offset_flag = false
          @task.offset = offset.to_f
        end
      end
    else

      @task.start_date = @task.parse_date(params[:start_date])

    end

    @task.fixed_end_date = (params[:duration] == "1")

    if !@task.fixed_end_date

      @task.duration_in_days = (params[:duration_days_hours] == "Days")

      duration = params[:duration_period_select]

      puts "******" + duration.to_s

      if @task.bespoke_duration_flag
        if duration.blank? or duration == "Specify"
          duration = params[:duration_bespoke_period]
          @task.duration = duration.to_f
        else
          @task.duration = duration.to_f
          @task.bespoke_duration_flag=false
        end
      else
        puts "1******" + duration.to_s
        if duration== "Specify"
          @task.bespoke_duration_flag = true
        else
          @task.duration = duration.to_f
        end
      end

    else

      @task.end_date = @task.parse_date(params[:end_date])

    end


    @task.save(validate: false)

    @task.job.update_timings

    redirect_to edit1_task_path(@task)

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
    task.job. update_timings
    redirect_to edit_task_path(task)
  end

  def remove_users
    task= Task.find(params[:id])
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


  def offset_period_value(task)
    if task.bespoke_offset_flag
      "Specify"
    elsif task.offset_in_days
      task.offset.to_i
    else
      task.offset.to_f
    end
  end

  def duration_period_value(task)
    if task.bespoke_duration_flag
      "Specify"
    else
      @task.duration_is_days ? duration_days_stg(task.duration) : duration_hours_stg(task.duration)
    end
  end

  def duration_unit_text(task)
    task.duration_is_days ? "days" : "hours"
  end

  def action

    if Action.where(message_id: params[:message_id]).count==0
      action = Action.new
      action.message_id =params[:message_id]
    else
      action =  Action.where(message_id: params[:message_id]).first
    end

    action.content = params[:action_text]

#    action.do_date = ActiveSupport::TimeZone.parse(params[:action_date]) if params[:action_date]
    action.do_date = DateTime.parse params[:action_date] rescue Date.today() if params[:action_date]

    action.myusers.clear
    Myuser.all.each do |myuser|
      action.myusers << myuser if params["action_user" + myuser.id.to_s]
    end
    action.save
    task_id = Message.find(action.message_id).forum_name.sub!("task", "").to_i
    puts "******** Task_id ********" + task_id.to_s
    redirect_to tasks_message_forum_path(task_id)
  end

  def action_delete
    if Action.where(:id => params[:action_id]).count
      Action.find(params[:action_id].to_i).delete
    end

    redirect_to root_path
  end

  def action_update
    Action.all.each do |action|
      action.done = params["action_done"+action.id.to_s] == "1"
      action.save
    end
    redirect_to root_path
  end

  def message_forum
    @message_forum_name = "task" + @task.id.to_s
    @myusers_for_message_forum = @task.myusers
    @is_task = true
    render :layout => "message_forum"
  end

  def summons_email

    @task.myusers.each do |myuser|
      if params["check" + myuser.id.to_s] == "1"
        UserMailer.summons_email(params[:email_message],  myuser, @task, request.base_url.to_s).deliver_now
      end
    end
    @is_task = true
    render "summons_email_sent", :layout => "message_forum"

  end

  def summons_landing

  end

  helper_method :offset_period_value, :duration_period_value, :email_summons_text_task, :duration_unit_text


  private
    # Use callbacks to share common setup or constraints between actions.
    def get_task
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

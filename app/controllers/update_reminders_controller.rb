class UpdateRemindersController < ApplicationController
  before_action :set_update_reminder, only: [:show, :edit, :update, :destroy]

  # GET /update_reminders
  # GET /update_reminders.json
  def index
    @update_reminders = UpdateReminder.all
  end

  # GET /update_reminders/1
  # GET /update_reminders/1.json
  def show
  end

  # GET /update_reminders/new
  def new
    @update_reminder = UpdateReminder.new
  end

  def new_for_task
    set_task
    setup_new_reminder
    @update_reminder.task = @task
    @update_reminder.is_for_task = true
    @update_reminder.reminder_schedule =  ReminderSchedule.first  #This is a dummy since this is a required field
    @update_reminder.save(validate: false)

    if !@task.for_template_flag
      @job =  @task.job
      @client = @job.client
    end
    edit1
  end

  def new_for_schedule
    set_schedule
    setup_new_reminder
    @update_reminder.is_for_task = false
    @update_reminder.reminder_schedule = @reminder_schedule
    @update_reminder.task = Task.first
    @update_reminder.save
    edit1
  end

  def setup_new_reminder
    @update_reminder = UpdateReminder.new
    @update_reminder.is_for_task = false
    @update_reminder.update_type = 0
    @update_reminder.proportion = 0.5

    @update_reminder.start_end = true
    @update_reminder.offset_days = 1
    @update_reminder.repeat_weekday = 2
    @update_reminder.before_after = true
    @update_reminder.offset_hours = 0
    @update_reminder.repeat_time = DateTime.parse(Rails.configuration.working_day_start_time)
    @update_reminder.update_window_percentage_flag = false
    @update_reminder.update_window_length_in_seconds = 4.hours
    @update_reminder.update_window_percentage = 0.05
    @update_reminder.reminder_schedule_id

    @update_reminder.allow_email_flag = true
  end

  # GET /update_reminders/1/edit
  def edit


    if @update_reminder.is_for_task
      @task =  @update_reminder.task
    else
      @reminder_schedule =  @update_reminder.reminder_schedule
    end
    edit1
  end

  def edit1
    @update_options = [[ "Proportion", 0 ], [ "Fixed to start/end", 1 ], [ "Regular", 2] ]
    @progress = []
    (0..20).each do |a|
      @progress << [(a * 5).to_s , a.to_f / 20 ]
    end

    @options_for_window_length = []

    @options_for_window_length << ["None" , 0]
    @options_for_window_length << ["Half an hour" , 0.5.hours]
    @options_for_window_length << ["One hour" , 1.hours]
    @options_for_window_length << ["Two hours" , 2.hours]
    @options_for_window_length << ["Three hours" , 3.hours]
    @options_for_window_length << ["Four hours" , 4.hours]
    @options_for_window_length << ["Siz hours" , 6.hours]
    @options_for_window_length << ["8 hours" , 8.hours]
    @options_for_window_length << ["12 hours" , 12.hours]
    @options_for_window_length << ["One day" , 1.days]
    @options_for_window_length << ["Two days" , 2.days]

    render 'edit'

  end

  # POST /update_reminders
  # POST /update_reminders.json
  def create
    @update_reminder = UpdateReminder.new(update_reminder_params)

    respond_to do |format|
      if @update_reminder.save
        format.html { redirect_to @update_reminder, notice: 'Update reminder was successfully created.' }
        format.json { render :show, status: :created, location: @update_reminder }
      else
        format.html { render :new }
        format.json { render json: @update_reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /update_reminders/1
  # PATCH/PUT /update_reminders/1.json
  def update
    update_fields
    redirect_to edit_update_reminder_path(@update_reminder)
  end

  def update_fields
    set_update_reminder
    @update_reminder.update_type = params[:update_type].to_i
    @update_reminder.proportion = params[:proportion].to_f
    @update_reminder.start_end = params[:start_end] ==  "start"
    @update_reminder.before_after =  params[:before_after] ==  "before"
    if !params[:offset_days].blank?
      @update_reminder.offset_days = params[:offset_days]
    end

    # d = params[:working_day_start]
    # if !d.blank?
    #   working_day_start_string = d["(4i)"] + ":" + d["(5i)"]
    #   @job.working_day_start = ActiveSupport::TimeZone[time_zone].parse(working_day_start_string)
    # else
    #   @job.working_day_start = ActiveSupport::TimeZone[time_zone].parse(Rails.configuration.working_day_start_time)
    # end

    if !params[:offset_hours].blank?
      @update_reminder.offset_hours = params[:offset_hours]
    end

    if @update_reminder.update_type ==  2
      @update_reminder.repeat_weekday = \
          (params[:mon] ==  "1" ? 0b0000001 : 0) + \
          (params[:tue] ==  "1" ? 0b0000010 : 0) + \
          (params[:wed] ==  "1" ? 0b0000100 : 0) + \
          (params[:thu] ==  "1" ? 0b0001000 : 0) + \
          (params[:fri] ==  "1" ? 0b0010000 : 0) + \
          (params[:sat] ==  "1" ? 0b0100000 : 0) + \
          (params[:sun] ==  "1" ? 0b1000000 : 0)

      d = params[:repeat_time]
      if !d.blank?
        repeat_time = d["(4i)"] + ":" + d["(5i)"]
        @update_reminder.repeat_time = Time.parse(repeat_time)
      else
        @update_reminder.repeat_time = ActiveSupport::TimeZone[@update_reminder.task.job.time_zone].parse(Rails.configuration.working_day_start_time)
      end

    end

    @update_reminder.update_window_percentage_flag = params[:update_window] == "1"
    @update_reminder.update_window_length_in_seconds = params[:update_window_length].to_i
    puts "update_window_length_in_seconds = " + @update_reminder.update_window_length_in_seconds.to_s
    @update_reminder.update_window_percentage = params[:update_window_percentage]


    @update_reminder.allow_email_flag = params[:email] == "1"

    @update_reminder.save(validate: false)

    #@update.offset = params[:start_end] ==  "1"


  end

  def update_and_return
    update_fields
    redirect_to edit_task_path(@update_reminder.task)
  end


  # DELETE /update_reminders/1
  # DELETE /update_reminders/1.json
  def destroy
    @update_reminder.destroy
  end

    private
  def set_task
    @task = Task.find(params[:taskid])
  end

  def set_schedule
    @reminder_schedule =  ReminderSchedule.find(params[:scheduleid])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_update_reminder
    @update_reminder = UpdateReminder.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def update_reminder_params
    params.require(:update_reminder).permit(:type, :proportion, :start_end, :offset, :day_time)
  end


end

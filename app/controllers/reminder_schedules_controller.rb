class ReminderSchedulesController < ApplicationController
  before_action :set_reminder_schedule, only: [:show, :edit, :update, :destroy]

  # GET /reminder_schedules
  # GET /reminder_schedules.json
  def index
    @reminder_schedules = ReminderSchedule.all
  end

  # GET /reminder_schedules/1
  # GET /reminder_schedules/1.json
  def show
  end

  # GET /reminder_schedules/new
  def new
    @reminder_schedule = ReminderSchedule.new
    @reminder_schedule.save
    edit1
  end

  # GET /reminder_schedules/1/edit
  def edit
  end

  def edit1
    render 'edit'
  end
  # POST /reminder_schedules
  # POST /reminder_schedules.json
  def create
    @reminder_schedule = ReminderSchedule.new(reminder_schedule_params)

    respond_to do |format|
      if @reminder_schedule.save
        format.html { redirect_to @reminder_schedule, notice: 'Reminder schedule was successfully created.' }
        format.json { render :show, status: :created, location: @reminder_schedule }
      else
        format.html { render :new }
        format.json { render json: @reminder_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_reminder
    reminder=UpdateReminder.find(params[:id])
    @reminder_schedule=reminder.reminder_schedule
    reminder.destroy
    redirect_to edit_reminder_schedule_path(@reminder_schedule)

  end

  # PATCH/PUT /reminder_schedules/1
  # PATCH/PUT /reminder_schedules/1.json
  def update
    respond_to do |format|
      if @reminder_schedule.update(reminder_schedule_params)
        format.html { redirect_to @reminder_schedule, notice: 'Reminder schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @reminder_schedule }
      else
        format.html { render :edit }
        format.json { render json: @reminder_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reminder_schedules/1
  # DELETE /reminder_schedules/1.json
  def destroy
    @reminder_schedule.destroy
    respond_to do |format|
      format.html { redirect_to reminder_schedules_url, notice: 'Reminder schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reminder_schedule
      @reminder_schedule = ReminderSchedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reminder_schedule_params
      params.require(:reminder_schedule).permit(:name)
    end
end

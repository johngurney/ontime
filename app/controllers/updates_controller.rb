class UpdatesController < ApplicationController
  before_action :set_update, only: [:show, :edit, :update, :destroy]

  # GET /updates
  # GET /updates.json
  def index
    @updates = Update.all
  end

  # GET /updates/1
  # GET /updates/1.json
  def show
  end

  # GET /updates/new
  def new
    @update = Update.new
  end

  def new_for_task
    set_task
    @progress=[]
    (0..10).each do |a|
      @progress << (a * 10).to_s # + '%'
    end
    render 'new'
  end

  def list_updates_for_task
    set_task
    render 'index'

  end

  # GET /updates/1/edit
  def edit
  end

  # POST /updates
  # POST /updates.json
  def create
    @update = Update.new(update_params)

    respond_to do |format|
      if @update.save
        format.html { redirect_to @update, notice: 'Update was successfully created.' }
        format.json { render :show, status: :created, location: @update }
      else
        format.html { render :new }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /updates/1
  # PATCH/PUT /updates/1.json
  def update_progress

    set_task
    @task.completed_flag = params[:completed] == "1"
    @task.percentage_completed = params[:progress].to_i
    @task.save(validate: false)

    update = Update.new
    update.myuser = logged_in_user_helper
    update.task=@task
    update.completed_flag = @task.completed_flag
    update.percentage_completed = @task.percentage_completed
    update.comments = params[:comments]
    update.percentage_time_passed = (Time.now - @task.start_date) / (@task.end_date - @task.start_date)*100

    update.save(validate: false)
    redirect_to root_path

  end

  # DELETE /updates/1
  # DELETE /updates/1.json
  def destroy
    @update.destroy
    respond_to do |format|
      format.html { redirect_to updates_url, notice: 'Update was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_update
      @update = Update.find(params[:id])
    end

  def set_task
    @task = Task.find(params[:taskid])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
    def update_params
      params.require(:update).permit(:myuser_id, :task_id, :comments)
    end
end

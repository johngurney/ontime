class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # GET /templates
  # GET /templates.json
  def index
    @templates = Template.all
  end

  def new
    @template = Template.new
    @template.save
    edit1
  end

  # GET /templates/1/edit
  def edit
    edit1
  end

  def edit1
    render 'edit'
  end
  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: 'Reminder schedule was successfully created.' }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_task
    task=Task.find(params[:id])
    @template=task.template
    task.destroy
    redirect_to edit_template_path(@template)

  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    @template.update(template_params)
    redirect_to edit_template_path(@template)

  end

  # POST /templates
  # POST /templates.json

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url, notice: 'Template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_template
    @template = Template.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def template_params
    params.require(:template).permit(:name, :comments)
  end
end


class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @client=@contact.client

  end

  # GET /contacts/new
  def new_contact_for_client

    @contact = Contact.new
    @contact.client_id = params[:id]
    render 'new'
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    client_id = params[:contact][:client_id]
    client=Client.find(client_id)

    @contact= Contact.new (contact_params)
    @contact.client_id = client_id
    if @contact.save
      redirect_to client_path(client)
    else
      redirect_to client_path(client)
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json

  def update
    @contact.update(contact_params)
    if @contact.save
      redirect_to @contact
    else
      render 'edit'
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :client_id, :telephone_number, :email, :position, :priority, :comments)
    end
end

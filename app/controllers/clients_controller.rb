class ClientsController < ApplicationController

  before_action :set_client, only: [:show, :show_with_all_fes, :edit, :update, :destroy, :add_users, :client_users]

  def index
    @clients=Client.all.order("created_at DESC")
  end

  def new
    @client=Client.new
  end

  def create
    @client = Client.new (client_params)
    if @client.save
      redirect_to @client
    else
      render new
    end
  end

  def edit

  end

  def update
    @client.update(client_params)
    if @client.save
      redirect_to @client
    else
      render 'edit'
    end

  end

  def show
    show1 false
  end

  def show_with_all_fes
    show1 true
  end

  def show1(flag)
    @show_all_fes_flag=flag
    @myusers = Myuser.all
    @contacts = @client.contacts
    @jobs = @client.jobs
    puts "+++" + @jobs.count.to_s
    @clientmyusers=@client.myusers
    @clients=Client.all.order("created_at DESC")
    render 'show'
  end

  def client_users

    if params[:function] == "Remove user(s)"
      myusers = @client.myusers
      myusers.each do |myuser|
        s = params['check'+myuser.id.to_s]
        if !s.blank?
          @client.myusers.delete(myuser)
        end
      end
      @client.save
      redirect_to client_path(@client)
    elsif params[:function] == "Add user(s)"
      myusers = Myuser.all
      myusers.each do |myuser|
        s = params['check'+myuser.id.to_s]
        if !s.blank?
          puts "***" + myuser.id.to_s
          if @client.myusers.where("myuser_id=?", myuser.id).count==0 #Just to ensure not already assigned as a user
            puts "+++" + myuser.id.to_s
            @client.myusers << myuser
          end
        end
      end
      @client.save
      redirect_to client_path(@client)

    elsif params[:function] == "Add as superviser(s)"
      myusers = @client.myusers
      myusers.each do |myuser|
        s = params['check'+myuser.id.to_s]
        if !s.blank?
          superviser=Superviser.new
          superviser.client_id=@client.id
          superviser.myuser_id=myuser.id
          superviser.save(validate: false)
        end
      end
      redirect_to client_path(@client)

    elsif params[:function] == "Remove superviser(s)"
      puts "%%%%%%%%"
      myusers = @client.myusers
      myusers.each do |myuser|
        s = params['check'+myuser.id.to_s]
        if !s.blank?
          Superviser.where('client_id=? AND myuser_id=?', @client.id, myuser.id).delete
        end
      end
      redirect_to client_path(@client)

    elsif params[:function] == "Show other user(s)"
      redirect_to show_with_all_fes_path(@client)
    elsif params[:function] == "Hide other user(s)"
      redirect_to client_path(@client)
    end

  end

  def delete_job
    set_job
    @client=@job.client
    @job.delete
    redirect_to client_path(@client)

  end

  private

  def set_client
    @client= Client.find(params[:id])
  end

  def set_job
    @job= Job.find(params[:jobid])
  end

  def client_params
    params.require(:client).permit(:name)
  end

end

class MyusersController < ApplicationController

  before_action :find_myuser, only: [:show, :edit, :update, :destroy]
  @@minimum_password_length=8

  def index
    @search_term =""
    @team_term = ""
    @office_term = ""
    @position_term = ""
    @experience_term = ""
    @allmyusers = Myuser.all
    @myusers=Myuser.all
  end

  #"%#{params[:search]}%"

  def search

    @allmyusers = Myuser.all
    @myusers = Myuser.all
    @search_term = params[:search]
    if !@search_term.blank?
      @myusers = Myuser.where('first_name LIKE ? OR last_name LIKE ? ', '%'+ @search_term +"%" , '%'+ @search_term +"%")
    end

    @team_term = params[:team]
    if !@team_term.blank?
      @myusers = @myusers.where(:team => @team_term)
    end

    @office_term= params[:office]
    if !@office_term.blank?
      @myusers = @myusers.where(:office => @office_term)
    end

    @position_term = params[:position]
    if !@position_term.blank?
      @myusers = @myusers.where(:position => @position_term )
    end

    @experience_term = params[:experience]
    if !@experience_term.blank?
      @myusers = @myusers.where(:experience => @experience_term)
    end

    render 'index'

  end


  def show

  end

  def edit

  end

  def new
    @myuser=Myuser.new
  end

  def create

    email=params[:myuser][:email]
    if Myuser.where(:email => email).count > 0 && false

      if Myuser.where(:email => email).count > 1
        #Do some code here to remove the additional users (which shouldn't be there!)
      end

      @myuser = Myuser.where(:email => params[:myuser][:email]).last
      if @myuser.has_confirmed_flag
        @myuser=Myuser.new
        add_to_alert "That email is already registered"
        render 'index'
      else
        @resend_email_message="That email has already been registered but the user has not confirmed.  Resend confirmation email?"
        render 'user_setup/new_user_resend_email'

      end

    else
      @myuser= Myuser.new (myuser_params)
      raw, enc = Devise.token_generator.generate(User, :confirmation_token )
      @myuser.confirmation_token = enc
      base_url = request.base_url.to_s #+ "new_user/" + user.confirmation_token

      @myuser.confirmation_sent_at = DateTime.now
      if Myuser.where(:user_status => "Admin").count == 0
        @myuser.user_status="Admin"
        add_to_alert  "Please note that this user was registered with admin user status since there are no other users with that status."
      end

      @myuser.save
      UserMailer.confirmation_email(@myuser, base_url).deliver_now

      render 'email_has_been_sent'

    end

  end

  def new_user_confirmation

    #This is the initial response to receiving the email with the confirmation
    @myuser = Myuser.where(:confirmation_token => params[:confirmation_token]).last

    puts "***" + @myuser.email
    @minimum_password_length=@@minimum_password_length

    current_time = Time.current #+ 2.days
    com_sent =@myuser.confirmation_sent_at

    #diff=Date.new(2009, 10, 13) - Date.new(2009, 10, 11)
    diff_in_days= (current_time - com_sent)/1.day

    if diff_in_days >= 2
      @resend_email_message="You are out of time to confirm.  Resend confirmation email?"
      render 'user_setup/new_user_resend_email'
    else
      render 'user_setup/new_user_confirmation'
    end

  end

  def update
    find_myuser
    password = params[:myuser][:password]
    if password.blank?
      if @myuser.has_confirmed_flag
        @myuser.update(myuser_params)
        @myuser.save

      else

      end
    else
      password_confirmation = params[:myuser][:password_confirmation]
      if encode_password?(@myuser, password, password_confirmation)
        session[:logged_in_user]= @myuser.id
        register_log_on
        @myuser.update(myuser_params)
        @myuser.save
        redirect_to root_path
      else
        render 'edit'
      end
    end
  end


  #This is the response after the user has entered the further details


  def encode_password?(myuser, password, password_confirmation)

    if password.length>=@@minimum_password_length && password==password_confirmation
      myuser =Myuser.find(params[:id])
      myuser.update(params.require(:myuser).permit(:first_name, :last_name ))
      encrypted_password=User.new(password: password).encrypted_password
      myuser.encrypted_password=encrypted_password
      true

    else
      if password.length < @@minimum_password_length
        add_to_alert"Password too short"
      end
      if password!=password_confirmation
        add_to_alert"Passwords not the same" + ": password=" + password.to_s + "; password confirm=" + password_confirmation.to_s
      end
      false

    end
  end

  def new_user_resend_email
    myuser = Myuser.find(params[:id])
    raw, enc = Devise.token_generator.generate(User, :confirmation_token )
    myuser.confirmation_token = enc
    base_url = request.base_url.to_s

    myuser.confirmation_sent_at=DateTime.now

    myuser.save
    UserMailer.confirmation_email(myuser, base_url).deliver_now
    render 'user_setup/new_user_ok'

  end


  def destroy
    @myuser.delete
    render 'index'
  end

  private

  def find_myuser
    @myuser = Myuser.find(params[:id])
  end

  def myuser_params
    params.require(:myuser).permit(:email, :first_name, :last_name, :user_status)
  end
end

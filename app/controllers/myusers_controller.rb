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
    @myusers=Myuser.where(:has_confirmed_flag => true)
  end

  def new_user
    @myuser=Myuser.new
    render 'new_user'
  end

  def search

    @allmyusers = Myuser.where(:has_confirmed_flag => true)
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

  def test1
    @myuser=Myuser.first
    render 'confirmation_out_time'
  end



  def create

    email=params[:myuser][:email]

    if Myuser.where(:email => email).count > 0 && false #temp code to allow more than one dan.tench@gmail.com email address

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
        render 'new_user_resend_email'

      end

    else

      @myuser= Myuser.new (myuser_params)

      if @myuser.user_status == Rails.configuration.super_admin_name or @myuser.user_status == Rails.configuration.admin_name

        render "password_check_for_making_new_admin"
      else
        create_myuser_and_send_email myuser
      end
    end

  end

  def confirm_for_new_admin_user
    password=params[:password]
    if test_password(Myuser.find(session[:logged_in_user]), password)

#    params.require(:myuser).permit(:email, :first_name, :last_name, :user_status)

      @myuser= Myuser.new (params.permit(:email, :first_name, :last_name, :user_status))
      puts "+++" + @myuser.user_status.to_s
      create_myuser_and_send_email
    else
      @alert_message="Incorrect password"
      render "password_check_for_making_new_admin"
    end
  end

  def create_myuser_and_send_email()

    puts "***" + @myuser.user_status.to_s

    raw, enc = Devise.token_generator.generate(User, :confirmation_token )
    @myuser.confirmation_token = enc
    base_url = request.base_url.to_s #+ "new_user/" + user.confirmation_token

    @myuser.confirmation_sent_at = DateTime.now
    if Myuser.where(:user_status => Rails.configuration.super_admin_name).count == 0
      @myuser.user_status = Rails.configuration.super_admin_name
      add_to_alert  "Please note that this user was registered with admin user status since there are no other users with that status."
    end

    @myuser.save
    UserMailer.confirmation_email(@myuser, base_url).deliver_now

    render 'email_has_been_sent'


  end

  def new_user_confirmation

    #This is the initial response to receiving the email with the confirmation
    @myuser = Myuser.where(:confirmation_token => params[:confirmation_token]).last

    if @myuser.has_confirmed_flag

      render 'new_user_invitation_already_completed'

    else
      @minimum_password_length=@@minimum_password_length

      current_time = Time.current #+ 2.days
      com_sent =@myuser.confirmation_sent_at

      #diff=Date.new(2009, 10, 13) - Date.new(2009, 10, 11)
      diff_in_days= (current_time - com_sent)/1.day

      if diff_in_days >= 2
        @resend_email_message="You are out of time to confirm.  Please asked for a new invitation to be sent."
        render 'new_user_resend_email'
      else
        render 'new_user_confirmation'
      end
    end

  end

  def myuser_amend
    find_myuser
    @myuser.update(params.permit(:email, :first_name, :last_name, :user_status, :experience, :team, :position, :office, :work_tel, :mobile_tel, :home_tel, :other_tel1, :other_tel2 ))
    @myuser.save

    redirect_to myuser_path(@myuser)
  end


  def update_user
    find_myuser
    @myuser.update(myuser_all_params)
    @myuser.save

    redirect_to myuser_path(@myuser)
  end

  def user_invite_return

    find_myuser

    password = params[:password]
    password_confirmation = params[:password_confirmation]
    if encode_password?(@myuser, password, password_confirmation)

      session[:logged_in_user]= @myuser.id
      register_log_on(@myuser)
      @myuser.update(params.permit(:first_name, :last_name))
      @myuser.has_confirmed_flag=true
      @myuser.save
      redirect_to root_path
    else
      alert_message = "Passwords don't match or insufficiently long"
      redirect_to myuser_path(@myuser)
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
        register_log_on(@myuser)
        @myuser.update(params.require(:myuser).permit(:first_name, :last_name))
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
      myuser = Myuser.find(params[:id])
      myuser.update(params.permit(:first_name, :last_name ))
      encrypted_password=User.new(password: password).encrypted_password
      myuser.encrypted_password=encrypted_password
      myuser.save


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

  # def new_user_resend_email
  #   myuser = Myuser.find(params[:id])
  #   raw, enc = Devise.token_generator.generate(User, :confirmation_token )
  #   myuser.confirmation_token = enc
  #   base_url = request.base_url.to_s
  #
  #   myuser.confirmation_sent_at=DateTime.now
  #
  #   myuser.save
  #   UserMailer.confirmation_email(myuser, base_url).deliver_now
  #   render 'new_user_ok'
  #
  # end


  def destroy
    @myuser.delete
    render 'index'
  end

  def login
    @myuser=Myuser.new
    render 'login'
  end

  def login_submit
    email=params[:email]
    if Myuser.where(:email => email).count==0
      @alert="Not a valid email address"
      login()
    else
      myuser=Myuser.where(:email => email).last
      password=params[:password]

      if test_password(myuser, password)
        register_log_on (myuser)
        redirect_to root_path
      else
        @alert="Incorrect password"
        login()
      end
    end
  end

  def logout
    session[:logged_in_user]= nil
    cookies[:logged_in_token]= nil
    redirect_to root_path
  end

  def upload_user_file
    uploaded_io = params[:file]
    text=uploaded_io.read
    TempUser.delete_all

    flag = false
    first_name_column = -1
    last_name_column = -1
    experience_column = -1
    team_column = -1
    position_column = -1
    office_column = -1
    email_column = -1


    text.each_line do |line|
      values=line.split "\t"
      if flag == false
        first_name_column=find_in_array(values, "first name")
        last_name_column=find_in_array(values, "last name")
        experience_column=find_in_array(values, "experience")
        team_column=find_in_array(values, "team")
        position_column=find_in_array(values, "position")
        office_column=find_in_array(values, "office")
        email_column=find_in_array(values, "email")
        flag=true
      else
        user=TempUser.new
        if first_name_column >= 0
          user.first_name = values[first_name_column]
        end
        if last_name_column >= 0
          user.last_name  = values[last_name_column]
        end
        if experience_column >= 0
          user.experience  = values[experience_column]
        end
        if team_column >= 0
          user.team       = values[team_column]
        end
        if position_column >= 0
          user.position   = values[position_column]
        end
        if office_column >= 0
          user.office     = values[office_column].strip
        end
        if email_column >= 0 or true
          user.email      = 'dan.tench@gmail.com'
        end
        user.save

      end


    end

    redirect_to list_temp_users_path

  end

  def delete_selected_users
    Myuser.all.each do |myuser|
      s = params['check'+myuser.id.to_s]
      if !s.blank?
        myuser.delete
      end
    end
    redirect_to myusers_path
  end

  def list_temp_users
    @tempusers=TempUser.all
  end

  def find_in_array(arry , text)
    a=arry.index{|v| v.downcase == text.downcase}
    if a.blank?
      -1
    else
      a
    end


  end

  def edit_temp_user
    @tempuser = TempUser.find(params[:id])
  end

  def update_temp_user
    tempuser = TempUser.find(params[:id])
    tempuser.update(params.require(:temp_user).permit(:email, :first_name, :last_name, :user_status))
    tempuser.save
    redirect_to list_temp_users_path
  end

  def test_password(myuser , password)

    user=User.new
    user.encrypted_password = myuser.encrypted_password
    user.valid_password?(password)

  end


  def import_users

    TempUser.all.each do |temp_user|
      s = params['check'+temp_user.id.to_s]
      if !s.blank?
        print "***" + temp_user.last_name

        myuser=Myuser.new
        myuser.first_name = temp_user.first_name
        myuser.last_name = temp_user.last_name
        myuser.experience = temp_user.experience
        myuser.team = temp_user.team
        myuser.position = temp_user.position
        myuser.office = temp_user.office
        myuser.email = temp_user.email
        myuser.save
      end
    end

    TempUser.delete_all

    redirect_to myusers_path
  end

  def invited_user_show
    @myuser = Myuser.find(params[:id])
    if !@myuser.has_confirmed_flag

    else
    end

  end

  def update_invited_user
    find_myuser

    @myuser.update(params.require(:myuser).permit(:first_name, :last_name, :user_status, :email))

    if params["commit"] == "Resend invitation"
      base_url = request.base_url.to_s
      UserMailer.confirmation_email(@myuser, base_url).deliver_now
      @myuser.confirmation_sent_at=DateTime.now

    end
    @myuser.save
    redirect_to myusers_path
  end

  private

  def find_myuser
    @myuser = Myuser.find(params[:id])
  end

  def myuser_params
    params.require(:myuser).permit(:email, :first_name, :last_name, :user_status)
  end

  def myuser_all_params
    params.require(:myuser).permit(:email, :first_name, :last_name, :user_status, :experience, :team, :position, :office, :work_tel, :mobile_tel, :home_tel, :other_tel1, :other_tel2 )
  end
end

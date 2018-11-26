class UserSetupController < ApplicationController

  @@minimum_password_length=8

  def index
    @myusers=Myuser.all
    render 'user_setup/index'
  end

  def show
    @myuser = Myuser.find(params[:id])
    render 'user_setup/show'
  end

  def new_user
    @myuser=Myuser.new
    render 'user_setup/new_user'
  end

  def new_user_details
    email=params[:myuser][:email]
    if Myuser.where(:email => email).count > 0
      if Myuser.where(:email => email).count > 1
        #Do some code here to remove the additional users (which shouldn't be there)
      end
      @myuser = Myuser.where(:email => params[:myuser][:email]).last
      if @myuser.has_confirmed_flag
        @myuser=Myuser.new
        @alert="That email is already registered"
        render 'user_setup/new_user'
      else
        @resend_email_message="That email has already been registered but there user has not confirmed.  Resend confirmation email?"
        render 'user_setup/new_user_resend_email'

      end

    else
      myuser= Myuser.new (new_user_details_params)
      raw, enc = Devise.token_generator.generate(User, :confirmation_token )
      myuser.confirmation_token = enc
      base_url = request.base_url.to_s #+ "new_user/" + user.confirmation_token

      myuser.confirmation_sent_at=DateTime.now
      if Myuser.where(:user_status => Rails.configuration.super_admin_name).count == 0
        myuser.user_status=Rails.configuration.super_admin_name
        @alert = "Please note that this user was registered with " + Rails.configuration.super_admin_name + " status since there are no other users with that status."
      end

      myuser.save
      UserMailer.confirmation_email(myuser, base_url).deliver_now
      render 'user_setup/new_user_ok'
    end

  end


  def login
    @myuser=Myuser.new
    render 'user_setup/user_login'
  end

  def login_response
    email=params[:myuser][:email]
    if Myuser.where(:email => email).count==0
      @alert="Not a valid email address"
      login()
    else
      myuser=Myuser.where(:email => email).last
      password=params[:myuser][:password]

      if test_password(myuser, password)
        register_log_on
        goto_homepage
      else
        @alert="Incorrect password"
        login()
      end
    end
  end

  def logout
    session[:logged_in_user]= nil
    cookies[:logged_in_token]= nil
    goto_homepage
  end



  def goto_homepage
    redirect_to root_url_helper
  end

  def test_password(myuser , password)

    user=User.new
    user.encrypted_password = myuser.encrypted_password
    user.valid_password?(password)

  end

  def test1
    #Myuser.delete_all
    redirect_to root_path
  end

  def test2
    update=Update.first
    update.save(validate:false)
    goto_homepage
  end

  def test3

    File.readlines('D:\Projects\temp.txt').each do |line|
      values=line.split "\t"
      myuser=Myuser.new
      myuser.first_name = values[0]
      myuser.last_name  = values[1]
      myuser.experience  = values[2]
      myuser.team       = values[3]
      myuser.position   = values[4]
      myuser.office     = values[5].strip
      myuser.email      = 'dan.tench@gmail.com'

      myuser.save

    end
    goto_homepage
  end

  def new_user_details_params
    params.require(:myuser).permit(:user_status, :first_name, :last_name, :email)
  end

end

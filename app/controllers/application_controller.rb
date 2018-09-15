class ApplicationController < ActionController::Base
  attr_accessor :resend_email_message


  include ActionController::Helpers

  def alert_helper
    if flash[:alert]
      flash[:alert]
    end
  end

  def add_to_alert(alert_message)
    if flash[:alert]
      flash[:alert] += alert_message
    else
      flash[:alert] = alert_message
    end

  end

  def logged_in_user_helper
    if session[:logged_in_user]
      Myuser.find(session[:logged_in_user])
    else
      token = cookies[:logged_in_token]
      if token
        puts "Token " + token
        if LoggedOnLog.where(:token=> token).count >0
          session[:logged_in_user]=LoggedOnLog.where(:token=> token).first.user
          puts "Found user from cookie " + Myuser.find(session[:logged_in_user]).email
          Myuser.find(session[:logged_in_user])
        end
      end
    end


  end

  def resend_email_message_helper
    if @resend_email_message
      @resend_email_message
    end
  end

  def email_confirmation_url(user)
    'email_conf/' + user.id.to_s
  end

  def root_url_helper
    request.base_url.to_s
  end

  def register_log_on
    puts "===log on"
    session[:logged_in_user]=myuser.id
    raw, enc = Devise.token_generator.generate(User, :confirmation_token )
    cookies.permanent[:logged_in_token]=enc
    log=LoggedOnLog.new
    log.token=enc
    log.user=myuser.id
    log.last_use = Time.current
    log.save

  end

  helper_method :email_confirmation_url
  helper_method :alert_helper, :logged_in_user_helper, :root_url_helper


end

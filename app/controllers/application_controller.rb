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
      get_user(session[:logged_in_user])
    else
      token = cookies[:logged_in_token]
      if token
        if LoggedOnLog.where(:token=> token).count >0
          session[:logged_in_user]=LoggedOnLog.where(:token=> token).first.user
          get_user(session[:logged_in_user])
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

  def register_log_on(myuser)
    session[:logged_in_user]=myuser.id
    raw, enc = Devise.token_generator.generate(User, :confirmation_token )
    cookies.permanent[:logged_in_token]=enc
    log=LoggedOnLog.new
    log.token=enc
    log.user=myuser.id
    log.last_use = Time.current
    log.save
  end

  def time_stg_at(t)
    t.strftime("%d %b %Y at %H:%M")

  end

  def telephone_link(tel_no)
      tel_no_mod = tel_no.to_s.scan(/(?:^\+)?\d+/)
      self.class.helpers.link_to tel_no, "#{tel_no_mod.join '-'}"
  end

  def email_summons_text_job(job)
    ApplicationController.renderer.render(partial: 'tasks/message_summons_email', locals: { task: nil , job: job, sending_user: logged_in_user_helper })
  end

  def email_summons_text_availability_job(job)
    ApplicationController.renderer.render(partial: 'tasks/message_summons_avail_email', locals: { task: nil , job: job, sending_user: logged_in_user_helper })
  end

  def email_summons_text_task(task)
    ApplicationController.renderer.render(partial: 'tasks/message_summons_email', locals: { task: task, job: nil, sending_user: logged_in_user_helper })
  end

  def duration_hours_stg(v)
    (v < 10) | (v != v.to_i) ? "%.1f" % v : "%.0f" % v
  end

  def duration_days_stg(v)
    "%.0f" % v 
  end


  helper_method :duration_stg

  helper_method :time_stg_at, :resend_email_message_helper
  helper_method :email_summons_text_job, :email_summons_text_availability_job
  helper_method :email_confirmation_url, :telephone_link
  helper_method :alert_helper, :root_url_helper

private

  def get_user(id)
    Myuser.find(id)  if Myuser.where(:id => id).count > 0
  end



end

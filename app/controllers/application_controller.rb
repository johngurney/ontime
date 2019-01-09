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

  def myusers_select_helper
  end

  def add_new_user_options
    #NB This will be called when logged_in_user_helper is blank only when there are no users, ie at first start up - the only option should be super user
    logged_in_user_helper.blank? ? [Rails.configuration.super_admin_name ] : logged_in_user_helper.add_new_user_options
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
    ApplicationController.renderer.render(partial: 'tasks/message_summons_email', locals: { task: task, job: task.job, sending_user: logged_in_user_helper })
  end

  def duration_hours_stg(v)
    (v < 10) | (v != v.to_i) ? "%.1f" % v : "%.0f" % v
  end

  def duration_days_stg(v)
    "%.0f" % v
  end

  def order_jobs_tasks_helper(task_job, field, homepage_hidepage = nil)
    if  logged_in_user_helper
      if (logged_in_user_helper.order_jobs_field == field  && task_job == "j") || (logged_in_user_helper.order_tasks_field == field  && task_job == "t")
        code = "&#x25B2".html_safe
      else
        code = "&#x25BC".html_safe
      end
      self.class.helpers.link_to '<span style="font-size: 10px">'.html_safe + code + '</span>'.html_safe , order_jobs_tasks_path(task_job: task_job , field: field, homepage_hidepage: homepage_hidepage)
    end
  end

  def progress_select_options
    options = []
      (0..10).each do |a|
        options << (a * 10).to_s + "%"
      end
      options
    end

  helper_method :duration_stg, :add_new_user_options

  helper_method :time_stg_at, :resend_email_message_helper
  helper_method :email_summons_text_job, :email_summons_text_availability_job
  helper_method :email_confirmation_url, :telephone_link
  helper_method :alert_helper, :root_url_helper
  helper_method :order_jobs_tasks_helper, :progress_select_options

private

  def get_user(id)
    Myuser.find(id)  if Myuser.where(:id => id).count > 0
  end



end

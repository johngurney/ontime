module ApplicationHelper

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

  private

  def get_user(id)
    Myuser.find(id)  if Myuser.where(:id => id).count > 0
  end


end

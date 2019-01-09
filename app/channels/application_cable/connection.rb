module ApplicationCable
  class Connection < ActionCable::Connection::Base

    identified_by :uuid

    def connect
      user_id = logged_in_user_helper
      if !user_id.blank?
        self.uuid = user_id
      end
    end


    def logged_in_user_helper
      token = cookies[:logged_in_token]
      if token
        if LoggedOnLog.where(:token=> token).count >0
          get_user(LoggedOnLog.where(:token=> token).first.user)
        end
      end


    end

    private

    def get_user(id)
      Myuser.find(id)  if Myuser.where(:id => id).count > 0
    end

  end

end

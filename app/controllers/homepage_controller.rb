class HomepageController < ApplicationController

  def homepage
    @tasks=[]
    @myuser = logged_in_user_helper

    if !@myuser.blank?
      @tasks=@myuser.tasks
    end

  end

end

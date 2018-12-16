class HomepageController < ApplicationController

  def homepage
    puts "**************** HOMEPAGE ****************"
    @tasks=[]
    @myuser = logged_in_user_helper

    if !@myuser.blank?
      @tasks=@myuser.tasks
    end

  end

end

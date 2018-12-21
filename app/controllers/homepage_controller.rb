class HomepageController < ApplicationController

  def homepage
    puts "**************** HOMEPAGE ****************"
    @tasks=[]
    @myuser = logged_in_user_helper

    if !@myuser.blank?
      @tasks=@myuser.tasks
    end

    require "browser/aliases"

    Browser::Base.include(Browser::Aliases)

    @browser = Browser.new("Some user agent")

    if @browser.mobile?
      render "mobile_homepage"
    end
  end

end

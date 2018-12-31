class HomepageController < ApplicationController

  def homepage
    puts "**************** HOMEPAGE ****************"
    @tasks=[]
    @myuser = logged_in_user_helper

    if !@myuser.blank?
      @tasks=@myuser.tasks
    end

    # require "browser/aliases"
    #
    # Browser::Base.include(Browser::Aliases)
    #
    # @browser = Browser.new("Some user agent")
    #
    # if @browser.mobile?
    #   render "mobile_homepage"
    # end

    # if browser.device.mobile? or true
    #   if @myuser or true
    #
    #     render "mobile/login", layout: "mobile"
    #   end
    # end


  end

  def tasks_include
    if logged_in_user_helper

      myuser =  Myuser.find(logged_in_user_helper.id)
      myuser.show_tasks_by_client = ( params[:tasks_include_clients] == "1" )
      myuser.show_tasks_by_job = ( params[:tasks_include_jobs] == "1" )
      myuser.show_tasks_by_task = ( params[:tasks_include_tasks] == "1" )
      myuser.save

    end
    redirect_to root_path

  end

  def jobs_include
    if logged_in_user_helper

      myuser =  Myuser.find(logged_in_user_helper.id)
      myuser.show_jobs_by_client = ( params[:jobs_include_clients] == "1" )
      myuser.show_jobs_by_job = ( params[:jobs_include_jobs] == "1" )
      myuser.save

    end

    redirect_to root_path
  end

  def hide_jobs
  end

  def hide_selected_jobs
    puts "**** HIDE ****"
    logged_in_user_helper.jobs_for_myuser.each do |job|
      if params["hide" + job.id.to_s]=="1"
        Hide.create(:myuser_id => logged_in_user_helper.id , :element => "job" + job.id.to_s)
      end
    end
    redirect_to root_path
  end

  def unhide_selected_jobs
    puts "**** UNHIDE ****"
    Hide.where(:myuser_id => logged_in_user_helper.id).each do |hide|
      if hide.element[0,3] == "job"
        if params["unhide" + hide.element.sub("job","")]=="1"
          hide.delete
        end
      end
    end
    redirect_to root_path
  end
  def hide_tasks
  end

  def hide_selected_tasks

    logged_in_user_helper.tasks_for_myuser.each do |task|
      if params["hide" + task.id.to_s] =="1"
        Hide.create(:myuser_id => logged_in_user_helper.id , :element => "task" + task.id.to_s)
      end
    end
    redirect_to root_path
  end

  def unhide_selected_tasks

    Hide.where(:myuser_id => logged_in_user_helper.id).each do |hide|
      if hide.element[0,4] == "task"
        puts "&&&" + hide.element
        if params["unhide" + hide.element.sub("task","")] == "1"
          hide.delete
        end
      end
    end
    redirect_to root_path
  end

  def order_jobs_tasks

    myuser = Myuser.find(logged_in_user_helper.id)

    if params[:task_job]=="t"
      if myuser.order_tasks_field == params[:field]
        myuser.order_tasks_field = params[:field] + "_reverse"
      else
        myuser.order_tasks_field = params[:field]
      end
      myuser.save
    elsif params[:task_job]=="j"
      if myuser.order_jobs_field == params[:field]
        myuser.order_jobs_field = params[:field] + "_reverse"
      else
        myuser.order_jobs_field = params[:field]
      end
      puts "&&&" + params[:field]
      puts "&&&" + myuser.order_jobs_field.to_s
      myuser.save
    end

    if params[:homepage_hidepage] == "task_hide"
      redirect_to hide_tasks_path
    elsif params[:homepage_hidepage] == "job_hide"
      redirect_to hide_jobs_path
    else
      redirect_to root_path
    end
  end

end

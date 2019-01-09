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
        @resend_email_message="That email has already been registered but the user has not confirmed.  Resend confirmation email?"
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

  def reset_to_two_users

    # Myuser.delete_all
    #
    # myuser = Myuser.create(user_status: Rails.configuration.admin_name, first_name: "Dan", last_name: "Tench", email: "dan.tench@gmail.com", has_confirmed_flag: true )
    # encrypted_password=User.new(password: "password").encrypted_password
    # myuser.encrypted_password=encrypted_password
    # myuser.save
    #
    # myuser = Myuser.create(user_status: Rails.configuration.user_name, first_name: "John", last_name: "Gurney", email: "dan.tench@googlemail.com", has_confirmed_flag: true )
    # encrypted_password=User.new(password: "password").encrypted_password
    # myuser.encrypted_password=encrypted_password
    # myuser.save

    myuser = Myuser.create(user_status: Rails.configuration.user_name, first_name: "Fred", last_name: "Smith", email: "dan.tench@googlemail.com", has_confirmed_flag: true )
    encrypted_password=User.new(password: "password").encrypted_password
    myuser.encrypted_password=encrypted_password
    myuser.save

    myuser = Myuser.create(user_status: Rails.configuration.user_name, first_name: "Gabriella", last_name: "Surtees", email: "dan.tench@googlemail.com", has_confirmed_flag: true )
    encrypted_password=User.new(password: "password").encrypted_password
    myuser.encrypted_password=encrypted_password
    myuser.save

    myuser = Myuser.create(user_status: Rails.configuration.user_name, first_name: "Jeffrey", last_name: "Brown", email: "dan.tench@googlemail.com", has_confirmed_flag: true )
    encrypted_password=User.new(password: "password").encrypted_password
    myuser.encrypted_password=encrypted_password
    myuser.save


    redirect_to root_path
  end

  def add_jobs_and_tasks

    Job.delete_all
    Task.delete_all

    file_name = File.join(Rails.root, 'public', 'jobs_and_tasks.txt')

    f = File.open(file_name, "r")
    jobs = []
    job = {}
    tasks =[]
    flag = false
    f.each_line(chomp: true) do |line|
      entries = line.split("\t")
      if entries[0] != ""
        if flag
          job[:tasks] = tasks

          jobs.push job

          job = {}
          tasks =[]
        end
        job[:job]=entries[0]
        flag = true
      else
        tasks << entries[1]

      end
    end

    job[:tasks] = tasks
    jobs.push job

    puts jobs

    clients=[]
    Client.all.each do |client|
      clients << client.id
    end


    (0..19).each do |a|
      a =rand(0..jobs.count-1)
      puts clients[rand(0..clients.count-1)].to_s + "=>" + a.to_s + " " + jobs[a][:job].to_s

      job = Job.new
      job.set_up_new_job
      job.name = jobs[a][:job]
      job.client =  Client.find(clients[rand(0..clients.count-1)])
      job.start = DateTime.now - 20 + rand(40)
      if rand(0..4) == 1
        job.myusers << Myuser.find(54)
      end
      if rand(0..4) == 1
        job.myusers << Myuser.find(55)
      end
      job.save

      old_task_id = 0

      jobs[a][:tasks].each do |task_name|
        task = Task.new
        task.set_up_new_task
        task.name = task_name
        task.duration = rand(4..30)
        if old_task_id == 0
          task.link_to_start = true
          task.linked_flag = true
        else
          task.linked_to_task_id = old_task_id
          task.linked_flag = true
        end
        task.offset = rand(0..6)

        task.job = job
        if rand(0..19) == 1
          task.myusers << Myuser.find(54)
        end
        if rand(0..19) == 1
          task.myusers << Myuser.find(55)
        end

        task.save
        old_task_id = task.id
      end

      job.update_timings

    end

    redirect_to root_path
  end

  def set_up_clients
    Client.delete_all
    Job.delete_all
    Task.delete_all

    Myuser.all.each do |myuser|
      myuser.clients.all.each do |client|
        myuser.clients.delete(client)
      end

      myuser.jobs.all.each do |job|
        myuser.jobs.delete(job)
      end

      myuser.tasks.all.each do |task|
        myuser.jobs.delete(task)
      end

    end


    client = Client.create(name: "ABC Bank")
    client.myusers << Myuser.find(54)
    client.myusers << Myuser.find(55)
    client.save

    client = Client.create(name: "XYZ Limited")
    client.myusers << Myuser.find(54)
    client.save

    client = Client.create(name: "Fibre Inc")
    client.myusers << Myuser.find(54)
    client.save

    client = Client.create(name: "Imperium Limited")
    client.myusers << Myuser.find(55)
    client.save

    client = Client.create(name: "Spec List SA")
    client.myusers << Myuser.find(54)
    client.myusers << Myuser.find(55)
    client.save

    redirect_to root_path
  end

  def test1

    UpdateReminder.all.each do |reminder|
      reminder.update_window_percentage_flag = false

      reminder.update_window_length_in_seconds = 4.hours
      reminder.save(validate: false)
    end



    # Task.all.each do |task|
    #   case rand(0..4)
    #     when 0, 1, 2
    #
    #       update_reminder = UpdateReminder.new
    #       update_reminder.is_for_task = true
    #       update_reminder.task = task
    #       update_reminder.update_type = 0
    #       update_reminder.proportion = 0.5
    #       update_reminder.allow_email_flag=true
    #       update_reminder.save(validate: false)
    #
    #       update_reminder = UpdateReminder.new
    #       update_reminder.is_for_task = true
    #       update_reminder.task = task
    #       update_reminder.update_type = 0
    #       update_reminder.proportion = 0.9
    #       update_reminder.allow_email_flag=true
    #       update_reminder.save(validate: false)
    #
    #     when 3
    #       update_reminder = UpdateReminder.new
    #       update_reminder.is_for_task=  true
    #       update_reminder.task = task
    #       update_reminder.update_type = 2
    #       update_reminder.repeat_weekday = rand(0..2) != 0 ? 0b0010101 : 0b0000010
    #       update_reminder.repeat_time = ActiveSupport::TimeZone[task.job.time_zone].parse(Rails.configuration.working_day_start_time)
    #
    #       update_reminder.allow_email_flag=true
    #       update_reminder.save(validate: false)
    #
    #   end
    # end


    # Client.all.each do |client|
    #   client.myusers.all.each do |myuser|
    #     client.myusers.delete(myuser)
    #   end
    # end
    #
    # Job.all.each do |job|
    #   job.myusers.all.each do |myuser|
    #     job.myusers.delete(myuser)
    #   end
    # end
    #
    # Task.all.each do |task|
    #   task.myusers.all.each do |myuser|
    #     task.myusers.delete(myuser)
    #   end
    # end

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

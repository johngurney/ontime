Rails.application.routes.draw do

  resources :updates
  root 'homepage#homepage'
  #devise_for :users

  get 'test1' => 'user_setup#test1'
  get 'test2' => 'user_setup#test2'

  get 'new_user' => 'user_setup#new_user' , as:  :new_user
  #get 'myusers.:id' => 'user_setup#new_user_resend_email'
  #post 'myusers' => 'user_setup#new_user_details'
  #patch 'myusers.:id', :to => 'user_setup#new_user_confirm_details', :as => :myuser

  get 'myuser/confirmation' => 'myusers#new_user_confirmation'
  post 'myusers/search' => 'myusers#search'

  get 'login' => 'user_setup#login'
  post 'login_response' => 'user_setup#login_response'
  delete 'logout' => 'user_setup#logout'

  #get 'jobs.:clientid' => 'jobs#index_for_client'
  #get 'jobs/new.:clientid' => 'jobs#new'
  post 'clients/client_users/.:id', to:  "clients#client_users" , as:  :client_users

  get 'clients/show_with_all_fes/.:id', to:  "clients#show_with_all_fes" , as:  :show_with_all_fes


  get 'client/newcontact/.:id', to:  "contacts#new_contact_for_client" , as:  :new_contact_for_client
  get 'client/newjob/.:id', to:  "jobs#new_job_for_client" , as:  :new_job_for_client

  get 'job/newtask/.:jobid', to:  "tasks#new_task_for_job" , as:  :new_task_for_job

  get 'job/amendteam/.:id', to:  "jobs#amend_team" , as:  :job_amend_team
  post 'job/addusers/.:jobid', to:  "jobs#add_users" , as:  :job_add_user
  post 'job/removeusers/.:jobid', to:  "jobs#remove_users" , as:  :job_remove_user
  post 'task/addusers/.:id', to:  "tasks#add_users" , as:  :task_add_user
  post 'task/removeusers/.:id', to:  "tasks#remove_users" , as:  :task_remove_user

  post 'job/timing/.:id', to:  "jobs#timing" , as:  :job_timing
  get 'job/today/.:id', to:  "jobs#today" , as:  :job_today

  get 'update_reminder/new_for_task/.:taskid', to:  "update_reminders#new_for_task" , as:  :update_reminder_new_for_task
  get 'update_reminder/new_for_schedule/.:scheduleid', to:  "update_reminders#new_for_schedule" , as:  :update_reminder_new_for_schedule

  post '/update_reminders/:id', to: "update_reminders#update", as: :update_reminder_update
  post '/update_reminders_and_return/:id', to: "update_reminders#update_and_return", as: :update_reminder_update_and_return

  post 'update_reminder/delete_from_schedule/.:id', to:  "reminder_schedules#delete_reminder" , as:  :delete_reminder_from_schedule
  get 'update_reminder/delete_from_task/.:id', to:  "tasks#delete_reminder" , as:  :delete_reminder_from_task

  post 'template/delete/.:id', to:  "templates#delete_task" , as:  :delete_task_from_template

  get 'tasks/new_task_for_job/.:jobid', to:  "tasks#new_task_for_job" , as:  :task_new_for_job
  get 'tasks/new_task_for_template/.:templateid', to:  "tasks#new_task_for_template" , as:  :task_new_for_template

  post 'task/linked_flag/.:id', to:  "tasks#linked" , as:  :task_linked
  post 'task/timing/.:id', to:  "tasks#timing" , as:  :task_timing
  get 'task/progress/.:id', to:  "tasks#progress" , as:  :task_update_progress
  post 'task/reminders_completed/.:id', to:  "tasks#reminders_completed" , as:  :task_reminders_completed
  get 'job/delete_task/.:taskid', to:  "jobs#delete_task" , as:  :job_delete_task
  get 'client/delete_job/.:jobid', to:  "clients#delete_job" , as:  :client_delete_job

  post 'job/import_template/.:id', to:  "jobs#import_template" , as:  :jobs_import_template
  get 'job/delete_all_tasks/.:id', to:  "jobs#delete_all_tasks" , as:  :jobs_delete_all_tasks
  post 'task/import_schedule/.:id', to:  "tasks#import_schedule" , as:  :tasks_import_schedule

  post 'update/progress/.:taskid', to:  "updates#update_progress" , as:  :update_progress
  get 'update/new_for_task/.:taskid', to:  "updates#new_for_task" , as:  :update_new_for_task

  get 'update/list_updates_for_task/.:taskid', to:  "updates#list_updates_for_task" , as:  :list_updates_for_task
  #get 'clients' => 'jobs#index_for_client'

  resources :clients
  resources :jobs
  resources :myusers
  resources :templates
  resources :reminder_schedules
  resources :update_reminders
  resources :tasks
  resources :contacts

  #devise_scope :user do
   # get 'users/confirmation' => 'users/registrations#email_confirm'
   # post 'users/email_conf/:userid' => 'users/registrations#email_sign_in'
   # patch 'users/email_conf/:userid' => 'users/registrations#email_sign_in'
  #end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

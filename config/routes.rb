Rails.application.routes.draw do

  resources :updates
  root 'homepage#homepage'
  #devise_for :users

  get 'test1' => 'user_setup#test1', as: :test1
  get 'test2' => 'user_setup#test2', as: :test2
  get 'reset_to_two_users'=> 'user_setup#reset_to_two_users', as: :reset_to_two_users
  get 'add_jobs_and_tasks'=> 'user_setup#add_jobs_and_tasks', as: :add_jobs_and_tasks

  get 'set_up_clients'=> 'user_setup#set_up_clients', as: :set_up_clients

  get 'hide_jobs'=> 'homepage#hide_jobs', as: :hide_jobs
  post 'hide_selected_jobs'=> 'homepage#hide_selected_jobs', as: :hide_selected_jobs
  post 'unhide_selected_jobs'=> 'homepage#unhide_selected_jobs', as: :unhide_selected_jobs
  get 'order_jobs_tasks'=> 'homepage#order_jobs_tasks', as: :order_jobs_tasks

  get 'hide_tasks'=> 'homepage#hide_tasks', as: :hide_tasks
  post 'hide_selected_tasks'=> 'homepage#hide_selected_tasks', as: :hide_selected_tasks
  post 'unhide_selected_tasks'=> 'homepage#unhide_selected_tasks', as: :unhide_selected_tasks

  get 'new_user' => 'myusers#new_user' , as:  :new_user

  get 'tasks/message_forum/.:id' => 'tasks#message_forum', as: :tasks_message_forum
  get 'jobs/message_forum/.:id' => 'jobs#message_forum', as: :jobs_message_forum
  post 'task_summons_email/.:id' => 'tasks#summons_email', as: :task_summons_email
  post 'job_summons_email/.:id' => 'jobs#summons_email', as: :job_summons_email
  get 'tasks/summons_landing/.:id' => 'tasks#summons_landing', as: :summons_landing

  post 'jobs_selection' => 'homepage#jobs_include', as: :homepage_jobs_include
  post 'tasks_selection' => 'homepage#tasks_include', as: :homepage_tasks_include


  #get 'myusers.:id' => 'user_setup#new_user_resend_email'
  #post 'myusers' => 'user_setup#new_user_details'
  #patch 'myusers.:id', :to => 'user_setup#new_user_confirm_details', :as => :myuser

  get 'myuser/confirmation' => 'myusers#new_user_confirmation'
  get 'myuser/invited_user_show/.:id' => 'myusers#invited_user_show', as: :invited_user_show
  patch 'myuser/update_invited_myuser/.:id' => 'myusers#update_invited_user', as: :update_invited_user
  patch 'myuser/myuser_amend/.:id' => 'myusers#myuser_amend', as: :myuser_amend
  #patch 'myuser/update_user/.:id' => 'myusers#update_user', as: :update_user

  post 'myuser/user_invite_return/.:id' => 'myusers#user_invite_return', as: :user_invite_return
  post 'myuser/confirm_for_new_admin_user' => 'myusers#confirm_for_new_admin_user', as: :confirm_for_new_admin_user

  post 'myusers/search' => 'myusers#search', as:  :myusers_search

  get 'login' => 'myusers#login', as:  :login
  post 'login_submit' => 'myusers#login_submit', as:  :login_submit
  delete 'logout' => 'myusers#logout', as: :logout

  #get 'jobs.:clientid' => 'jobs#index_for_client'
  #get 'jobs/new.:clientid' => 'jobs#new'
  post 'clients/client_users/.:id', to:  "clients#client_users" , as:  :client_users
  post 'clients/search', to:  "clients#search" , as:  :clients_search

  get 'clients/show_with_all_fes/.:id', to:  "clients#show_with_all_fes" , as:  :show_with_all_fes


  get 'client/newcontact/.:id', to:  "contacts#new_contact_for_client" , as:  :new_contact_for_client
  get 'client/newjob/.:id', to:  "jobs#new_job_for_client" , as:  :new_job_for_client
  post 'upload_user_file', to:  "myusers#upload_user_file" , as:  :upload_user_file
  post 'import_users', to:  "myusers#import_users" , as:  :import_users
  get 'edit_temp_user/.:id', to:  "myusers#edit_temp_user" , as:  :edit_temp_user
  post 'temp_user/.:id', to:  "myusers#update_temp_user" , as:  :temp_user
  get 'list_temp_users', to:  "myusers#list_temp_users" , as:  :list_temp_users
  delete 'delete_selected_users', to:  "myusers#delete_selected_users" , as:  :delete_selected_users

  get 'job/newtask/.:jobid', to:  "tasks#new_task_for_job" , as:  :new_task_for_job

  get 'job/amendteam/.:id', to:  "jobs#amend_team" , as:  :job_amend_team
  post 'job/addusers/.:jobid', to:  "jobs#add_users" , as:  :job_add_user
  post 'job/removeusers/.:jobid', to:  "jobs#remove_users" , as:  :job_remove_user
  post 'task/addusers/.:id', to:  "tasks#add_users" , as:  :task_add_user
  post 'task/removeusers/.:id', to:  "tasks#remove_users" , as:  :task_remove_user

  post 'job/timing/.:id', to:  "jobs#timing" , as:  :job_timing
  get 'job/today/.:id', to:  "jobs#today" , as:  :job_today
  get 'job/now/.:id', to:  "jobs#now" , as:  :job_now

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
  get 'task/.:id/edit1', to:  "tasks#edit1" , as:  :edit1_task
  post 'task/progress/.:id', to:  "tasks#progress" , as:  :task_update_progress
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

  post 'action_update' => 'tasks#action_update', as: :action_update
  post 'action/.:message_id' => 'tasks#action', as: :action
  post 'action_delete/.:action_id' => 'tasks#action_delete', as: :action_delete


  get 'cannot_access' => 'general#cannot_access', as: :cannot_access


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
  mount ActionCable.server => "/cable"
end

class AddFlagFieldsToMyuser < ActiveRecord::Migration[5.2]
  def change
    add_column :myusers, :show_jobs_by_client, :boolean
    add_column :myusers, :show_jobs_by_job, :boolean
    add_column :myusers, :show_tasks_by_client, :boolean
    add_column :myusers, :show_tasks_by_job, :boolean
    add_column :myusers, :show_tasks_by_task, :boolean
  end
end

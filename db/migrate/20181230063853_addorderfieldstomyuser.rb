class Addorderfieldstomyuser < ActiveRecord::Migration[5.2]
  def change
    add_column :myusers, :order_jobs_field, :boolean
    add_column :myusers, :order_tasks_field, :boolean
  end
end

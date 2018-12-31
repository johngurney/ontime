class Changeorderfieldstomyuser < ActiveRecord::Migration[5.2]
  def change
    change_column :myusers, :order_jobs_field, :string
    change_column :myusers, :order_tasks_field, :string
  end
end

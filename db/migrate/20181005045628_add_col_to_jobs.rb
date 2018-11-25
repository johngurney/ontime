class AddColToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :include_weekends, :boolean
  end
end

class AddClientifToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :Client_id, :integer
  end
end

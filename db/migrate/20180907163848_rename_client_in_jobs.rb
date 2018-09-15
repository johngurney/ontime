class RenameClientInJobs < ActiveRecord::Migration[5.2]
  def change
    rename_column :jobs, :Client_id, :client_id
  end
end

class RenameInTask < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :start_end_flag, :link_to_start
    rename_column :tasks, :duration_enddate_flag, :fixed_end_date
  end
end

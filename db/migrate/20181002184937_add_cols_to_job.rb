class AddColsToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :time_zone, :string
    add_column :jobs, :working_day_start, :datetime
    add_column :jobs, :working_day_end, :datetime
  end
end

class AddDailyFlagToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :daily_flag, :boolean
  end
end

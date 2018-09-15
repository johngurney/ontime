class AddFieldToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :client, :integer
    add_column :jobs, :comment, :text
    add_column :jobs, :start, :datetime
    add_column :jobs, :end, :datetime
  end
end

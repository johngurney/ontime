class AddCommentsToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :comments, :text
  end
end

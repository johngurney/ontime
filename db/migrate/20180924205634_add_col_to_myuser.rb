class AddColToMyuser < ActiveRecord::Migration[5.2]
  def change
    add_column :myusers, :request_another_confirmation_email, :boolean
  end
end

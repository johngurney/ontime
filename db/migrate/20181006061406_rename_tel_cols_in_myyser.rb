class RenameTelColsInMyyser < ActiveRecord::Migration[5.2]
  def change
    rename_column :myusers, :mobile_tel2, :other_tel2
  end
end

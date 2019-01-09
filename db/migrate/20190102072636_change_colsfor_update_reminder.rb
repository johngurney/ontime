class ChangeColsforUpdateReminder < ActiveRecord::Migration[5.2]
  def change
    change_column :update_reminders, :repeat_weekday,'integer USING (repeat_weekday::bool::int)'
#    , 'boolean USING (start_end::int::bool)'
  end
end

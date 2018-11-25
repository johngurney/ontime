class Myuser < ApplicationRecord
  has_and_belongs_to_many :clients
  has_and_belongs_to_many :jobs
  has_and_belongs_to_many :tasks
  has_many :update_reminders, :through => :tasks
  has_many :updates
  has_and_belongs_to_many :actions

  def confirmation_sent_at_string
    date_stg self.confirmation_sent_at
  end

  def date_stg(date_value)
    if date_value.blank?
      ""
    else
      date_value.strftime("%e %b %Y at %H:%M")
    end
  end

  def name
    self.first_name + " " + self.last_name
  end

  def add_new_user_options
    if self.user_status == Rails.configuration.super_admin_name
      [Rails.configuration.super_admin_name , Rails.configuration.admin_name, Rails.configuration.user_name, Rails.configuration.client_name]
    elsif self.user_status == Rails.configuration.admin_name
      [Rails.configuration.user_name, Rails.configuration.client_name]
    end
  end

end

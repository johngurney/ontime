class Myuser < ApplicationRecord
  has_and_belongs_to_many :clients
  has_and_belongs_to_many :jobs
  has_and_belongs_to_many :tasks
  has_many :update_reminders, :through => :tasks
  has_many :updates

end

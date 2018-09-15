class Client < ApplicationRecord
  has_and_belongs_to_many :myusers
  has_many :contacts
  has_many :jobs
end

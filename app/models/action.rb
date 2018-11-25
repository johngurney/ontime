class Action < ApplicationRecord
  belongs_to :message
  has_and_belongs_to_many :myusers
end

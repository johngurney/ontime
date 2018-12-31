class Client < ApplicationRecord
  has_and_belongs_to_many :myusers
  has_many :contacts
  has_many :jobs

  def myuser_is_superviser(myuser)
    myuser.is_admin? or Superviser.where('client_id=? AND myuser_id=?', self.id, myuser.id).count > 0
  end
end

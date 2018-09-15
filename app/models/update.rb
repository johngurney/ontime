class Update < ApplicationRecord
  belongs_to :task
  belongs_to :myuser

  def created_at_date_stg()
      created_at.strftime("%d %b %Y, %H:%M")
  end

end

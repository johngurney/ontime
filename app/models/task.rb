class Task < ApplicationRecord
  belongs_to :job
  belongs_to :template
  has_and_belongs_to_many :myusers
  has_many :update_reminders
  has_many :updates

  def start_datestg
    if self.start_date.blank?
      ""
    else
      self.start_date.strftime("%d %b %M")
    end
  end

  def start_datestg
    date_stg(self.start_date)
  end

  def end_datestg
    date_stg(self.end_date)
  end

  def date_stg(date_value)
    if date_value.blank?
      ""
    else
      date_value.strftime("%d %b %Y")
    end
  end

  def parse_date(date_hash)
    if !date_hash.blank?
      Date.new( date_hash["(1i)"].to_i, date_hash["(2i)"].to_i, date_hash["(3i)"].to_i )
    end

  end

end

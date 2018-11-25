class Task < ApplicationRecord
  belongs_to :job, optional: true
  belongs_to :template, optional: true
  has_and_belongs_to_many :myusers
  has_many :update_reminders
  has_many :updates

  def start_date_timestg
    self.job.check_if_timezone_exists_and_valid
    if  self.job.daily_flag
      date_stg(self.start_date.in_time_zone(self.job.time_zone))
    else
      date_time_stg(self.start_date.in_time_zone(self.job.time_zone))
    end
  end

  def end_date_timestg
    self.job.check_if_timezone_exists_and_valid
    if !self.end_date.blank?
      if  self.job.daily_flag
        date_stg(self.end_date.in_time_zone(self.job.time_zone))
      else
        date_time_stg(self.end_date.in_time_zone(self.job.time_zone))
      end
    end
  end

  def date_stg(date_value)
    if date_value.blank?
      ""
    else
      date_value.strftime("%a, %d %b %Y")
    end
  end

  def date_time_stg(date_value)
    if date_value.blank?
      ""
    else
      date_value.strftime("%a, %e %b %Y %H:%M")
    end
  end

  def duration_to_s
    if self.duration.to_i == self.duration
      self.duration.to_i.to_s
    else
      self.duration.to_s
    end
  end

  def parse_date(date_hash)
    if !date_hash.blank?
      Date.new( date_hash["(1i)"].to_i, date_hash["(2i)"].to_i, date_hash["(3i)"].to_i )
    end

  end

  def duration_is_days
    self.job.daily_flag | self.duration_in_days
  end

end

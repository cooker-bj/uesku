class ClassTime < ActiveRecord::Base
  attr_accessible :end_time, :start_time, :timetable_id
  belongs_to :timetable


  def start_day
    start_time.try(:strftime,"%Y-%m-%d")||Time.now.strftime("%Y-%m-%d")
  end

  def end_day
    end_time.try(:strftime,"%Y-%m-%d")||Time.now.strftime("%Y-%m-%d")
  end

  def week
    start_time.try(:wday)||Time.now.wday
  end

  def start_time_hour
    start_time.try(:hour)||Time.now.hour
  end

  def start_time_minute
    start_time.try(:min)||Time.now.min
  end

  def end_time_hour
    end_time.try(:hour)||Time.now.hour
  end

  def end_time_minute
    end_time.try(:min)||Time.now.min
  end
end

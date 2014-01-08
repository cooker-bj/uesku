class ClassTime < ActiveRecord::Base
  attr_accessible :end_time_hour,:end_time_minute, :start_time_hour,:start_time_hour,:start_time_minute,
                  :week,:start_day,:end_day,:name, :timetable_id
  belongs_to :timetable



end

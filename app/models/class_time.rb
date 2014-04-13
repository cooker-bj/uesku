class ClassTime < ActiveRecord::Base
  attr_accessible :end_time_hour,:end_time_minute, :start_time_hour,:start_time_hour,:start_time_minute,
                  :week,:start_day,:end_day,:name, :timetable_id
  belongs_to :timetable

  def events
    interval=week.to_i-start_day.wday
    interval=interval<0 ? 7+interval :interval
    first_day=start_day+interval.days
    calendar_events=[]
    while first_day<=end_day
      calendar_events<<{
          id: self.id,
          start: (first_day+start_time_hour.to_i.hours+start_time_minute.to_i.minutes),
          end: (first_day+end_time_hour.to_i.hours+end_time_minute.to_i.minutes),
          title: self.name,
          allDay: false
      }
      first_day+=7.days
    end
    calendar_events
  end

  def self.events
    all.inject([]){|events_array,event| events_array.concat event.events}
  end
end

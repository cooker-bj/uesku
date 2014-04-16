class ClassTime < ActiveRecord::Base
  attr_accessible :end_time_hour,:end_time_minute, :start_time_hour,:start_time_minute,
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

  def remove_class_time(class_time)
    new_object=self.dup
    target_time=Time.parse(class_time).to_date
    previous_end_day=target_time.beginning_of_week-1.day
    next_start_day=previous_end_day+8.day
    case 
    when self.events.length==1 then self.destroy()
    when  previous_end_day <= self.start_day then  self.update_attributes({start_day: next_start_day})
    when  next_start_day >= self.end_day then  self.update_attributes({end_day: previous_end_day})
    else
      self.update_attributes({end_day: previous_end_day})
      new_object.start_day=next_start_day
      new_object.save
    end
    self.timetable.touch
  end

  def modify(event_time,args)
    params={
      start_time_hour: args[:start_time_hour],
      start_time_minute: args[:start_time_minute],
      end_time_hour: args[:end_time_hour],
      end_time_minute: args[:end_time_minute],
      start_day: args[:start_day],
      end_day: args[:start_day],
      week: Date.parse(args[:start_day]).wday,
      name: self.name,
      timetable_id: self.timetable_id
    }
    self.remove_class_time(event_time)
    ClassTime.create(params)
    self.timetable.touch
  end
end

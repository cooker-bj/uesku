class Timetable < ActiveRecord::Base
  attr_accessible :create_time, :creator_id, :description, :end_day, :lesson_id, :start_day, :title,:class_times_attributes
  has_many :class_times
  has_many :taken_classes
  has_many :users,:through=>:taken_classes
  belongs_to :lesson
  belongs_to :creator,:class_name=>'User',:foreign_key=>:creator_id
  before_create :add_create_time
  accepts_nested_attributes_for :class_times,:allow_destroy => true
  before_save :add_start_end_day
  def lesson_name
    lesson.try(:title)
  end

  def register(user)
    success=false

   unless self.users.include?(user)
     self.users<<user
     #--add class time to user's calendar_events

      calendar_events=class_times.inject([]){|events,time| events.concat time.events}
      calendar_events.each do |event|
         user.calendar_events.create(
            title: event[:title],
            start_time: event[:start],
            end_time: event[:end],
            event_group_id: 'timetable'+event[:id],
            source: 'timetable',
            location: self.lesson.address,
            notifications_attributes: [{:alert_before_event=>15},{:alert_before_event=>1200}]
        )
      end
     success=true
   end
    success
  end

  private

  def add_create_time
    self.create_time=Time.now
  end

  def add_start_end_day
    self.end_day=self.class_times.maximum('end_day')
    self.start_day=self.class_times.minimum('start_day')
  end

end

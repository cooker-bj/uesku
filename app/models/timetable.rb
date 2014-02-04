class Timetable < ActiveRecord::Base
  attr_accessible :create_time, :creator_id, :description, :end_day, :lesson_id, :start_day, :title,:class_times_attributes
  has_many :class_times,:dependent=>:destroy
  has_many :taken_classes,:dependent=>:destroy
  has_many :users,:through=>:taken_classes
  belongs_to :lesson
  belongs_to :creator,:class_name=>'User',:foreign_key=>:creator_id
  before_create :add_create_time
  accepts_nested_attributes_for :class_times,:allow_destroy => true
  before_save :add_start_end_day
  after_update :update_class_time_to_registers
  def lesson_name
    lesson.try(:title)
  end

  def register(user)
    self.users<<user if !self.users.include?(user) && user.add_to_calendar(self.build_calendar_for_user)
  end

  def unregister(user)
    
    self.users.delete(user) if self.users.include?(user) && !user.remove_timetable_events(self).blank?
  end



  def build_calendar_for_user
    calendar_events=self.class_times.inject([]){|events,time| events.concat time.events}
      built_events=calendar_events.inject([]) do |my_array,event|
         my_array<<{
            title: event[:title],
            start_time: event[:start],
            end_time: event[:end],
            event_group_id: event_group_id,
            source: 'timetable',
            description: description,
            location: self.lesson.address,
            repeat: true,
            timetable_name: self.title
          }
       end
       built_events.first.merge!({:alerts_attributes=>[{:alert_before_event=>'10',:when_to_alert=>'start'}]})
      built_events

  end

  def event_group_id
   'timetable'+self.id.to_s 
  end

  private
  def add_create_time
    self.create_time=Time.now
  end

  def add_start_end_day
    self.end_day=self.class_times.maximum('end_day')
    self.start_day=self.class_times.minimum('start_day')
  end

  def update_class_time_to_registers    
    self.users.each do |person|
      person.update_class_time(self)
      ShortMessage.send_system_message(person,"您使用的课表#{title}已被更新， 请查看")
    end
  end

end

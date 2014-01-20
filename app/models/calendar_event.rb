class CalendarEvent < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :description, :end_time, :event_group_id, :location, :source, :start_time, :title,:user_id,:notifications_attributes,
                  :all_day
  belongs_to :user
  #has_many :notifications
  validates_presence_of :title,:start_time,:end_time
  validate :start_less_end
  #accepts_nested_attributes_for :notifications,:allow_destroy => true
  DAY_UNIT={'天'=>:day,'周'=>:week,'月'=>:month,'年'=>:year}
  
  def self.remove_events(event_id,events_scope='current') #scope => %W'current' 'future' 'all'
    event=find(event_id)
    case 
        when events_scope=='future' && !event.event_group_id.blank? 
          where('event_group_id=? and start_time >= ?',event.event_group_id,event.start_time).destroy_all
        when 'all' && !event.event_group_id.blank? 
          where(:event_group_id=>event.event_group_id).destroy_all
        else
          [event.destroy]
        end
  end

 


  def self.add_events(params,repeat_params=nil)

    unless params[:start_time].blank? ||params[:end_time].blank? || params[:title].blank? || Time.parse(params[:start_time]) > Time.parse(params[:end_time])
      events=[]
      myalerts=params.delete :notifications_attributes
      unless repeat_params.blank?
        ntime=repeat_params[:time].to_i
        end_day=Time.parse(repeat_params[:end_day]) unless repeat_params[:end_day].blank?
        start=Time.parse(params[:start_time])
        during=Time.parse(params[:end_time])-start
        i=0

        my_group_id=create_group_id

        while ntime.try('>',i) ||end_day.try('>',start)

           events<<params.merge({
               :start_time=>start,
               :end_time=>start+during,
               :event_group_id=>my_group_id
           })


          start+=repeat_params[:repeat_every].to_i.send(repeat_params[:unit])
          i+=1
        end

      else

       events<<params

      end
      
      my_calendar_events=create(events)
      unless my_calendar_events.blank?
        args=myalerts.collect {|notification| notification.merge({:calendar_event_id=>my_calendar_events.first.event_group_id || my_calendar_events.first.id})}
        Notification.create(args)
      end
      my_calendar_events

      
    else
       nil
    end
  end


  def self.update_events(event_id,attrs,applied_to_all=false)
    my_event=self.find(event_id)
    myalerts=attrs.delete :notifications_attributes
    if(applied_to_all && (!my_event.event_group_id.blank?))
      illegal = false
      illegal=true if attrs.has_key?(:title) && attrs[:title].blank?
      illegal=true if attrs.has_key?(:start_time) && attrs[:start_time].blank?
      illegal=true if attrs.has_key?(:end_time) && attrs[:end_time].blank?
      illegal=true if attrs.has_key?(:start_time)&& attrs.has_key?(:end_time) && Time.parse(attrs[:start_time])>Time.parse(attrs[:end_time])
      illegal=true if attrs.has_key?(:start_time)&& !attrs.has_key?(:end_time) && Time.parse(attrs[:start_time])>my_event.end_time
      illegal=true if !attrs.has_key?(:start_time)&& attrs.has_key?(:end_time) && Time.parse(attrs[:end_time])<my_event.start_time
      unless illegal
        events=self.where(:event_group_id=>my_event.event_group_id)
        start_gap=Time.parse(attrs[:start_time])-my_event.start_time if attrs.has_key?(:start_time)
        end_gap= Time.parse(attrs[:end_time])-my_event.end_time if attrs.has_key?(:end_time)

        events.each do |event|
          params=attrs
          params.merge!({:start_time=>event.start_time+start_gap}) if attrs.has_key? :start_time
          params.merge!({:end_time=>event.end_time+end_gap}) if attrs.has_key? :end_time
            return nil unless event.update_attributes(params)
           
         
        end
        update_notifications(my_event,myalerts)
        events

      else
        nil
      end
    else
      if my_event.repeat
        my_event.notifications.each do |alert|
         my=alert.dup
         my.calendar_event_id=my_event.id
         my.save
        end
        attrs.merge!({:event_group_id=>nil})
      end 
      if my_event.update_attributes(attrs) 
        update_notifications(my_event,myalerts)
        [my_event]
      else
        nil
      end
    end

    
  end

  def notifications
    Notification.where(:calendar_event_id=>event_group_id||id)
  end

 

  def repeat
    !self.event_group_id.blank?
  end

  def repeat_every
    self.event_group_id.blank? ? 0 : CalendarEvent.where(:event_group_id=>self.event_group_id).count()
  end

  def end_period
    CalendarEvent.where(:event_group_id=>self.event_group_id).maximun('end_time') unless self.event_group_id.blank?
  end

  def get_url
    calendar_event_path(self)
  end

  def as_json(option={})
    super(option.merge(:methods=>[:get_url],:include=>[:notifications=>{:only=>[:alert_before_event]}]))

  end

  private

    def self.update_notifications(event,params)
      event.notifications
      params.try :each do |pa|
        if(pa[:_destroy])
          event.notifications.find(pa[:id]).destroy 
        elsif pa[:id].blank?
          Notification.create(pa.merge({:calendar_event_id=>event.event_group_id||event.id}))
        else 
          event.notifications.find(pa[:id]).update_attributes(:alert_before_event=>pa[:alert_before_event])
        end

      end

    end

    def start_less_end
      self.start_time<=self.end_time
    end
    

    def self.create_group_id
      gid="group#{Random.rand(10).to_s}"
      where(:event_group_id=>gid).blank? ? gid : create_group_id
    end
end

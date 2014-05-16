class CalendarEvent < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :description, :end_time, :event_group_id, :location, :source, :start_time, :title,:user_id,:alerts_attributes,
                  :all_day,:repeat,:timetable_name
  belongs_to :user
  has_many :alerts,:primary_key=>:event_group_id
  validates_presence_of :title,:start_time,:end_time
  validate :start_less_end
  before_save :add_group_id
  after_destroy :clean_alert
  accepts_nested_attributes_for :alerts,:allow_destroy => true
  DAY_UNIT={'天'=>:day,'周'=>:week,'月'=>:month,'年'=>:year}
  
  def self.remove_events(event_id,events_scope='current') #scope => %W'current' 'future' 'all'
    event=find(event_id)
      case 
        when events_scope=='future' && event.repeat
          where('event_group_id=? and start_time >= ?',event.event_group_id,event.start_time).destroy_all
        when events_scope=='all' && event.repeat
          where(:event_group_id=>event.event_group_id).destroy_all
        else
          [event.destroy]
        end
  end



 


  def self.add_events(params,repeat_params=nil)

    unless params[:start_time].blank? ||params[:end_time].blank? || params[:title].blank? || Time.parse(params[:start_time]) > Time.parse(params[:end_time])
      events=[]
     
      unless params[:repeat]=='0'||repeat_params.blank?
        ntime=repeat_params[:time].to_i
        group_alerts=params.delete(:alerts_attributes)
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
          logger.info "events=#{events}\n"
          i+=1
        end
        events.first.merge!({:alerts_attributes=>group_alerts})

      else

       events<<params

      end
      
      my_calendar_events=create(events)
      
      
    else
       nil
    end
  end


  def self.update_events(event_id,attrs,applied_to_all=false)
    my_event=self.find(event_id)
    
    if(applied_to_all && (my_event.repeat))
      result=[]
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
            params.try :delete,:alerts_attributes
            result<<event
          end
          result
       
      else
        nil
      end
    else
      if my_event.repeat
        attrs.merge!({:event_group_id=>create_group_id,:repeat=>false})
        attrs[:alerts_attributes].delete_if do |key,value| 
          value.try(:delete,'id')
          value.try(:fetch,'_destroy')
        end



      end
   
      if my_event.update_attributes(attrs) 
       
        [my_event]
      else
        nil
      end
    end

    
  end

  def self.range(start=nil,terminal=nil)
    case
    when start.nil? && terminal.nil?
      scoped
    when terminal.nil?
      where('start_time >? ',DateTime.strptime(start,'%s'))
    else
        where(:start_time=>DateTime.strptime(start,'%s')...DateTime.strptime(terminal,'%s'))
    end
  end

  
 

  
  def repeat_every
    self.event_group_id.blank? ? 0 : CalendarEvent.where(:event_group_id=>self.event_group_id).count()
  end

  def end_period
    CalendarEvent.where(:event_group_id=>self.event_group_id).maximun('end_time') unless self.event_group_id.blank?
  end

  def url
    calendar_event_path(self)
  end

  def as_json(option={})
   # super(option.merge(:methods=>[:url],:include=>[:alerts=>{:only=>[:alert_before_event,:when_to_alert]}]))
   json={:title=>title,
         :start=>start_time,
         :end=>end_time,
         :id=>event_group_id,
         :url=>url,
         :allDay=>all_day,
         :realId=>id,
         :timetable_name=>timetable_name,
         :location=>location,
         :description=>description
        }
    json[:alerts]=alerts.as_json(option)
    json


  end

  private

    
    def add_group_id
      self.event_group_id=self.event_group_id||self.class.create_group_id
    end

    def start_less_end
      self.start_time.try :<= ,self.end_time
    end
    

    def self.create_group_id
      gid="group#{Random.rand(100000000).to_s}"
      where(:event_group_id=>gid).blank? ? gid : create_group_id
    end

    def clean_alert
     self.alerts.destroy_all if CalendarEvent.where(:event_group_id=>self.event_group_id).blank?
    end
end

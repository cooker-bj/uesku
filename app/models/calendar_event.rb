class CalendarEvent < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :description, :end_time, :event_group_id, :location, :source, :start_time, :title,:user_id,:notifications_attributes,
                  :all_day
  belongs_to :user
  has_many :notifications
  accepts_nested_attributes_for :notifications,:allow_destroy => true
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
      create(events)
    else
       nil
    end
  end


  def self.update_events(event_id,attributes,applied_to_all=false)
    my_event=self.find(event_id)
    if(applied_to_all&& (!my_event.event_group_id.blank?))
    else
      my_event.update_attributes(attributes) ? [my_event] : nil
    end

    
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
    def self.create_group_id
      gid=Random.rand(10).to_s
      where(:event_group_id=>gid).blank? ? gid : create_group_id
    end
end

class CalendarEvent < ActiveRecord::Base
  attr_accessible :description, :end_time, :event_group_id, :location, :source, :start_time, :title,:user_id,:notifications_attributes
  belongs_to :user
  has_many :notifications
  accepts_nested_attributes_for :notifications
  DAY_UNIT={'天'=>:day,'周'=>:week,'月'=>:month,'年'=>:year}
  alias :old_destroy :destroy

  def self.add_events(params)
    if params[:repeat]
      ntime=params[:end_period][:time]
      end_day=Time.parse(params[:end_period][:end_day]) unless params[:end_period][:end_day].blank?
      start=Time.parse(params[:start_time])
      during=Time.parse(params[:end_time])-start
      i=0
      events=[]
      my_group_id=create_group_id
      while ntime.try('>',i) ||end_day.try('>',start)

        events<< create(:title=>params[:title],
               :start_time=>start,
               :end_time=>start+during,
               :user_id=>params[:user_id],

               :notifications_attributes=>params[:notifications_attributes],
               :description=>params[:description],
               :location=>params[:location],
               :event_group_id=>my_group_id

        )
        start+=params[:repeat_every].send(DAY_UNIT[params[:unit]])
        i+=1
      end
      events
    else
      [create(params)]

    end
  end

  def destroy(future=false)
    if future
      CalendarEvent.where("event_group_id=? and start_time>=?",self.event_group_id.to_s,self.start_time).each do |event|
        event.old_destroy
      end
    else
      self.old_destroy
    end
  end

  private
    def self.create_group_id
      gid=Random.rand(10)
      where(:event_group_id=>gid.to_s).blank? ? gid : create_group_id
    end
end

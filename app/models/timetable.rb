class Timetable < ActiveRecord::Base
  attr_accessible :create_time, :creator_id, :description, :end_day, :lesson_id, :start_day, :title,:class_times_attributes
  has_many :class_times
  belongs_to :lesson
  belongs_to :creator,:class_name=>'User',:foreign_key=>:creator_id
  before_create :add_create_time
  def class_times_attributes=(params)
    params.each do |item|
      start_class=Date.parse(item[:start_day])
      end_class=Date.parse(item[:end_day])
      interval=start_class.wday-item[:week].to_i
      interval=interval<0 ? interval+7 : interval
      first_day=start_class+interval
      while first_day <=end_day
       class_times.build(:start_time=>(first_day+item[:start_time_hour].to_i.hours+item[:start_time_minute].to_i.minutes),
                          :end_time=>(first_day+item[:end_time_hour].to_i.hours+item[:end_time_minute].to_i.minutes))
        first_day+=7.days
      end
    end

  end

  private

  def add_create_time
    create_time=Time.now
  end

end

class Timetable < ActiveRecord::Base
  attr_accessible :create_time, :creator_id, :description, :end_day, :lesson_id, :start_day, :title,:class_times_attributes
  has_many :class_times
  belongs_to :lesson
  belongs_to :creator,:class_name=>'User',:foreign_key=>:creator_id
  before_create :add_create_time
  accepts_nested_attributes_for :class_times,:allow_destroy => true
  before_save :add_start_end_day
  def lesson_name
    lesson.try(:title)
  end


  private

  def add_create_time
    create_time=Time.now
  end

  def add_start_end_day
    end_day=class_times.maximum('end_day')
    start_day=class_times.minimum('start_day')
  end

end

class TakenClass < ActiveRecord::Base
  #attr_accessible :timetable_id, :user_id
  belongs_to :user
  belongs_to :timetable
end

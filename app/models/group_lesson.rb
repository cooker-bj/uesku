class GroupLesson < ActiveRecord::Base
  #attr_accessible :group_id, :lesson_id
  belongs_to :group
  belongs_to :lesson
end

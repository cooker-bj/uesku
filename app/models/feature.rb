class Feature < ActiveRecord::Base
  attr_accessible :content, :course_id, :title
  belongs_to :course
  has_paper_trail
end

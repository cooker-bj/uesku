class Score < ActiveRecord::Base
  attr_accessible :course, :environment, :lesson_id, :security, :teacher, :user_id,:comment
  belongs_to :lesson
  has_one :comment
  belongs_to :user
  accepts_nested_attributes_for :comment
  after_save :count_score



  def comment=(attrs)
    unless attrs[:comment].nil?
    if comment.nil?
       self.build_comment(attrs)
    else
       comment.update_attributes(attrs)
      end

    end
  end


  private

  def count_score
    self.lesson.count_scores
  end

end

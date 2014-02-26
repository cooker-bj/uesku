class Score < ActiveRecord::Base
  attr_accessible :course, :environment, :lesson_id, :security, :teacher, :user_id
  belongs_to :lesson
  
  belongs_to :user
  
  after_save :count_score



  

  def as_json(option={})
    super(option.merge(:except=>[:lesson_id,:user_id,:created_at,:updated_at]))
  end


  private

  def count_score
    self.lesson.count_scores
  end

end

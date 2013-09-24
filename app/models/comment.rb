class Comment < ActiveRecord::Base
  attr_accessible :comment, :comment_time, :lesson_id, :user_id
  belongs_to :lesson
  belongs_to :user
  has_many :replies
  belongs_to :score
  before_save :add_comment_time

  def self.last_comment_user_name
   last.nil? ? nil :last.user.name
  end

  def self.last_comment
    last.nil? ? nil :last.comment
  end
  private
  def add_comment_time
    self.comment_time=Time.now
  end
end

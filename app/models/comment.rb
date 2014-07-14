class Comment < ActiveRecord::Base
  #attr_accessible :comment, :comment_time, :user_id,:commentable,:commentable_type
  belongs_to :commentable,:polymorphic => true
  belongs_to :user
  has_many :replies,:dependent=>:destroy
  validates_presence_of :comment
  before_create :add_comment_time
  after_create :update_commentable_after_create,:renew_score
  after_destroy :update_commentable_after_destroy

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
  def update_commentable_after_create
    if self.commentable.respond_to?(:comment_count)
         self.commentable.comment_count+=1 
         self.commentable.last_replier_id=self.user_id
         self.commentable.last_replied_time=Time.now
         self.commentable.save
    end
  end

  def update_commentable_after_destroy
    if self.commentable.respond_to?(:comment_count)
      self.commentable.comment_count-=1
   
      self.commentable.save
    end

  end

  def renew_score
    user.update_attributes(:score=>user.score+1)
  end
end

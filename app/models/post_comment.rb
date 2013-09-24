class PostComment < ActiveRecord::Base
  attr_accessible :comment_time, :message, :post_id, :user_id
  belongs_to :post
  belongs_to :user
  before_save :add_comment_time
  after_create :update_post_after_create
  after_destroy :update_post_after_destroy
  validates_presence_of :message
  def can_destroy?(user)
     self.user_id==user.id || self.post.group.manager?(user.id)
  end


  private
  def add_comment_time
    self.comment_time=Time.now
  end

  def update_post_after_create
         self.post.comment_count+=1
         self.post.last_replier_id=self.user_id
         self.post.last_replied_time=Time.now
         self.post.save
  end

  def update_post_after_destroy
    self.post.comment_count-=1
    if self.post.comment_count<0
      self.post.destroy
    else
      self.post.save
    end

  end
end

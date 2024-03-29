class Post < ActiveRecord::Base
  #attr_accessible  :posted_time, :poster_id, :title,:group_id,:content
  belongs_to :group
  has_many :comments,:as=>:commentable,:dependent=>:destroy
  
  belongs_to :last_replier, :class_name=>'User',:foreign_key=>:last_replier_id
  belongs_to :poster,:class_name=>'User',:foreign_key=>:poster_id
  before_create :add_posted_time
  after_create :renew_score
 

  def self.group_posts_list(group_id)
    self.where(:group_id=>group_id).order("set_to_top DESC, last_replied_time DESC")
  end

  def is_at_top?
    set_to_top==1
  end

  def set_top
    self.set_to_top=1
    save
  end

  def withdraw_to_top
    self.set_to_top=0
    save
  end

  def set_distillate
    self.distillate=true
    save
  end

  def withdraw_distillate
    self.distillate=false
    save
  end
  private
  def add_posted_time
    self.posted_time=Time.now
    self.comment_count=0
    self.last_replier_id=self.poster_id
    self.last_replied_time=Time.now
  end

  def renew_score
    poster.update_attributes(:score=>poster.score+8)
  end
end

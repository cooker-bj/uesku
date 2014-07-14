class Reply < ActiveRecord::Base
  #attr_accessible :comment_id, :message, :reply_time, :user_id
  belongs_to :user
  belongs_to :comment
  before_save :add_reply_time
  after_create :renew_score
  private
    def add_reply_time
      self.reply_time=Time.now
    end

    def renew_score
    user.update_attributes(:score=>user.score+1)
  end
end

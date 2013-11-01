class ShortMessage < ActiveRecord::Base
  attr_accessible :create_time, :media, :message, :message_group_id, :sender_id,:category
  belongs_to :message_group

  belongs_to :sender,:class_name=>'User',:foreign_key=>:sender_id
  mount_uploader :media, MessageUploader
  before_create :add_create_time
  after_save :update_status
  CATEGORY={'文字'=>0,'图片'=>1,'声音'=>2}

  def is_sender?(user)
    self.sender==user

  end



  private
    def add_create_time
      self.create_time=Time.now
    end

    def update_status
      message_group.message_group_users.each do |item|
        item.new_message unless item.user.id==sender_id
      end
    end

end

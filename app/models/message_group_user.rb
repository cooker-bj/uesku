class MessageGroupUser < ActiveRecord::Base
  attr_accessible :message_group_id, :user_id,:has_new_messages
  belongs_to :user
  belongs_to :message_group
  scope :new_messages, where(:has_new_messages=>true)

  def read
  self.update_attribute(:has_new_messages,false)
  end

  def new_message
    update_attribute(:has_new_messages,true) unless has_new_messages?
  end
end

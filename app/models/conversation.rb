class Conversation < ActiveRecord::Base
  attr_accessible :high_user_id, :low_user_id, :new_message_time, :unread_messages_number
  has_many :messengers

 def has_unread?
   :unread_messages_number>0
 end
  def other(user)
    if  self.high_user_id==user.id
      User.find(low_user_id)
    elsif user.id==low_user_id
      User.find(high_user_id)
    else
      nil
    end
  end

  def self.find_conversations(user)
    where("high_user_id=? or low_user_id=?",user.id,user.id).order("new_message_time DESC")
  end

  def read_one_message
    self.update_attribute(:unread_messages_number,unread_messages_number-1)
  end

  def sent_one_message
    self.update_attributes(:new_message_time=>Time.now,:unread_messages_number=>unread_messages_number+1)
  end

  def self.add_new_messenger(user1_id,user2_id)
    if user1_id > user2_id
      low_user_id,high_user_id=user2_id,user1_id
    else
      low_user_id,high_user_id=user1_id,user2_id
    end
    conversation=where(:low_user_id=>low_user_id,:high_user_id=>high_user_id).first
    conversation=self.create(:low_user_id=>low_user_id,:high_user_id=>high_user_id,:new_message_time=>Time.now) unless conversation
    conversation
  end
end

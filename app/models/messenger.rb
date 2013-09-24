class Messenger < ActiveRecord::Base
  attr_accessible :create_time, :message, :read_status, :receiver_id, :sender_id
  belongs_to :sender,:class_name=>"User",:foreign_key=>:sender_id
  belongs_to :receiver,:class_name=>'User',:foreign_key=>:receiver_id
  belongs_to  :conversation
  scope :read_messages, where(:read_status=>true)
  scope :unread_messages, where(:read_status=>false)
  validates_presence_of :message,:receiver_id,:sender_id
  before_create :fill_messages
  after_create :renew_conversation
  after_destroy :update_conversation

  def my_messages(user)
    where(:receiver_id=>user.id)
  end

  def has_read
   unless self.read_status
     self.update_attribute(:read_status,true)
     self.conversation.read_one_message
   end
  end



 def self.new_messages_count(user)
   where(:receiver_id=>user.id,:read_status=>false).count
 end

  def self.new_messages(user)
    where(:receiver_id=>user.id,:read_status=>false)
  end




  private
   def fill_messages
    self.conversation_id=Conversation.add_new_messenger(sender_id,receiver_id)
    self.create_time=Time.now
  end

  def renew_conversation
    self.conversation.sent_one_message

  end

  def update_conversation
    self.conversation.read_one_message unless self.read_status
  end
end

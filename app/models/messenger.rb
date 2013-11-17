class Messenger < ActiveRecord::Base
  attr_accessible :user_id,:message_group_id,:short_message_id,:read_status
  belongs_to :user
  belongs_to :message_group
  belongs_to :short_message

  def self.unread(group)
   where("messengers.read_status=? and short_messages.message_group_id=?",false,group.id).joins(:short_message)
  end


end

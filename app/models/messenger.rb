class Messenger < ActiveRecord::Base
  attr_accessible :user_id,:message_group_id,:short_message_id,:read_status
  belongs_to :user
  belongs_to :message_group
  belongs_to :short_message
  before_create :add_group_id

  def self.unread(group)
   where("messengers.read_status=? and message_group_id=?",false,group.id)
  end

  private

  def add_group_id
    self.message_group_id=self.short_message.message_group_id
  end


end

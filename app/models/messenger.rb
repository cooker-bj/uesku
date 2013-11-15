class Messenger < ActiveRecord::Base
  attr_accessible :user_id,:message_group_id,:short_message_id,:read_status
  belongs_to :user
  belongs_to :message_group
  belongs_to :short_message
  scope :unread,->{where(:read_status=>false)}

end

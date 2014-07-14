#--encoding: UTF-8
class Friendship < ActiveRecord::Base
  #attr_accessible :friend_id, :user_id,:status
  belongs_to :user
  belongs_to :friend,:class_name=>'User'
  validates_presence_of :friend_id,:user_id
  validates :friend_id,uniqueness: {scope: :user_id,:message=>'已是朋友/发出邀请'}
 scope :pending, where(:status=>false)
 scope :agreed, where(:status=>true)
end

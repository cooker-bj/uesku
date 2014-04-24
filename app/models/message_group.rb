class MessageGroup < ActiveRecord::Base
  attr_accessible :creator_id
  has_many :short_messages
  has_many :message_group_users
  has_many :users,:through=>:message_group_users
  belongs_to :creator, :class_name=>'User',:foreign_key=>:creator_id
  accepts_nested_attributes_for :short_messages
  before_create :add_create_time
  before_save :add_update_time
  validates_presence_of :creator_id
  def self.get_messages(gid,user)
       group=find(gid)
       gu=group.message_group_users.where(:user_id=>user.id).first
       gu.read
       group
  end

  def messages
    short_messages.order("create_time DESC")
  end

   def title
    users.inject(''){|title,user| title << user.name.to_s<<','}.chop
   end

  def has_new_messages(user)
      !self.message_group_users.where(:user_id=>user.id,:has_new_messages=>true).empty?
  end

  def add_users(users)
    users.each do |user|
      self.users<<User.find(user)
    end

  end

  def remove_users(users)
    users.each do |user|
      self.users.delete(User.find(user))
    end

  end


  def self.locate_users(group_users,current_user)
     my_users=group_users.inject([]){|us,u| us<<User.find(u)}
     my_users<<current_user
     my_group=nil
     current_user.message_groups.each do |group|
       my_group=group if group.users.to_set==my_users.to_set
     end
     unless my_group
       my_group=MessageGroup.new(:creator_id=>current_user.id)
       my_group.users+=my_users

       my_group.save
     end
     my_group
  end

  def as_json(option={})
    super(option.merge(:methods=>[:title],:only=>[:id,:creator_id,:update_time]))
  end


  
 private
  def add_create_time
    self.create_time=Time.now
  end

  def add_update_time
    self.update_time=Time.now
  end
end

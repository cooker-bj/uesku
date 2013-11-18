#encoding: UTF-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable,:omniauth_providers=>[:google_oauth2,:weibo,:qq]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:provider,:uid,:nickname,:real_name,:gender,:birthday,:avatar,:avatar_cache,:remote_avatar_url,:authenticated_tokens_attributes
  # attr_accessible :title, :body

  has_many :comments
  has_many :scores
  has_many :replies
  has_many :members
  has_many :posts,:foreign_key=>:poster_id
  has_many :post_comments
  has_many :owned_groups,:class_name=>'Group',:foreign_key => :owner_id
  has_many :groups,:through=>:members
  has_many :authenticated_tokens
  has_many :sent_messages,:class_name=>'ShortMessage',:foreign_key=>:sender_id
  has_many :message_group_users
  has_many :message_groups,:through=>:message_group_users
  has_many :short_messages,:class_name=>'ShortMessage',:through=>:messengers  do
    def unread_messages(group)
      where('messengers.read_status=? and short_messages.message_group_id=?',false,group.id)
    end
  end
  has_many :messengers

  has_many :friendships
  has_many :friends, :through=>:friendships
  has_many :inverse_friendships,:class_name=>'Friendship',:foreign_key=>:friend_id
  has_many :inverse_friends,:through=>:inverse_friendships,:source=>:user
  validates_presence_of :email,:real_name,:gender
  validates_uniqueness_of :nickname ,:allow_nil=>true
  mount_uploader :avatar,AvatarUploader
  accepts_nested_attributes_for :authenticated_tokens

  def self.find_for_oauth2(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    authentication = AuthenticatedToken.where(:provider =>access_token.provider ,:uid=>access_token.uid).first
    user=authentication.nil? ? nil : authentication.user
    if authentication.nil? && signed_in_resource.nil?
          user = User.create(real_name: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0,20],
                         gender:  data['gender'],
                         birthday: data['birthday'],
                         remote_avatar_url: data['picture'],
                         authenticated_tokens_attributes:[ {
                             provider:access_token.provider,
                             uid: access_token.uid,
                             access_token: access_token.credentials.token
                             } ]
                         )
    elsif authentication.nil?
          user=signed_in_resource
          user.authenticated_tokens.create(
                              provider:access_token.provider,
                              uid: data['id'],
                              access_token: access_token.credentials.token

          )
    end
    user
  end


  def my_friends
    self.friends.where("friendships.status=?",true).concat(self.inverse_friends.where("friendships.status=?",true))
  end

  def name
    self.nickname || self.real_name
  end


  def friends_applied_list
    self.friends.where("friendships.status=?",false)
  end

  def pending_friends
    self.inverse_friends.where("friendships.status=?",false)
  end

  def friends_recent_posts
    self.my_friends.empty? ? [] : self.my_friends.collect{|user| user.posts.where("posts.posted_time>?",2.days.ago)}.flatten

  end

  def friends_recent_post_comments
    self.my_friends.empty? ? [] :self.my_friends.collect{|user|user.post_comments.where('comment_time>?',2.days.ago)}.flatten
  end

  def friends_recent_comments
    self.my_friends.empty? ? [] :self.my_friends.collect{|user| user.comments.where("comment_time>?",2.days.ago)}.flatten
  end


  def has_new_message?
    self.message_group_users.new_messages.count>0
  end


  def read_new_messages(group)
    messengers=self.messengers.unread(group)
    messages=[]
    messengers.each do |messenger|
      messenger.update_attribute(:read_status,true)
      messages<< messenger.short_message
    end
    messages
  end


end

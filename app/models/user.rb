#encoding: UTF-8
class User < ActiveRecord::Base
  extend Users::OmniauthCallbacksHelper
  
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:trackable#,:omniauthable,:omniauth_providers=>[:google_oauth2,:weibo,:qq_connect]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:provider,:uid,:nickname,:real_name,:gender,:birthday,
                  :avatar,:avatar_cache,:remote_avatar_url,:authenticated_tokens_attributes,:location_id,:registration_date,:score
  # attr_accessible :title, :body
  scope :online, lambda{ where('update_at <?', 10.minutes.ago)}
  before_save :ensure_authentication_token
  has_many :comments
  has_many :scores
  has_many :ratings
  has_many :replies
  has_many :members
  has_many :posts,:foreign_key=>:poster_id
  has_many :pictures,:foreign_key=>:creator_id
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
  has_many :calendar_events
  has_many :created_timetables,:class_name=>'Timetable',:foreign_key=>:creator_id
  has_many :taken_classes
  has_many :timetables,:through=>:taken_classes
  has_many :places

  mount_uploader :avatar,AvatarUploader
  accepts_nested_attributes_for :authenticated_tokens
   before_create :add_random_nickname, :add_registration_date

def ensure_authentication_token
  if authentication_token.blank?
    self.authentication_token = generate_authentication_token
  end
end



  def self.find_for_oauth2(access_token, signed_in_resource=nil)
    user_attributes= user_hash(access_token)
    logger.info "raw_info:#{access_token.extra.raw_info}"
    authentication = AuthenticatedToken.where(:provider =>access_token.provider ,:uid=>access_token.uid.to_s).first
    user=authentication.nil? ? nil : authentication.user
    if authentication.nil? && signed_in_resource.nil?
          user = User.create(user_attributes)
    elsif authentication.nil?
          user=signed_in_resource
          user.authenticated_tokens.create(
                              provider:access_token.provider,
                              uid: access_token.uid.to_s,
                              access_token: access_token.credentials.token

          )
    end
    user
  end


  def my_friends
    self.friends.where("friendships.status=?",true).concat(self.inverse_friends.where("friendships.status=?",true))
  end

  def name
    self.nickname.blank? ? self.real_name : self.nickname
  end


  def applied_friends
    self.friends.where("friendships.status=?",false)
  end



  def pending_friends
    self.inverse_friends.where("friendships.status=?",false)
  end

  def friends_recent_posts
    self.my_friends.empty? ? [] : self.my_friends.collect{|user| user.posts.where("posts.posted_time>?",2.days.ago)}.flatten

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
    logger.debug "messenger=#{messengers.first}"
    messengers.each do |messenger|
      messenger.update_attribute(:read_status,true)
      logger.info "error: messenger.errors"
      messages<< messenger.short_message
    end

    messages
  end

  def online?
    updated_at < 10.minutes.ago
  end

  def self.date_format(date)

    match_year=/^([1|2]\d\d\d)-\d\d?-\d\d?$/
    begin
      mydate=DateTime.parse(date)
    rescue =>e
      if (year=match_year.match(date) )
          date=year[1]+"-01-01"
      else
        date="1970-01-01"
      end
       retry
    end
     mydate.strftime("%Y-%m-%d")
  end

  def self.get_gender(gender)
    gender=gender.chomp
    unless gender=='女' || gender=='男'
        gender=case gender
                 when 'male' then '男'
                 when 'female' then '女'
                 else
                   '男'
               end
    end
    gender
  end


  def my_events
    calendar_events.collect do |event|
      {
        id: event.event_group_id,
        start: event.start_time,
        end: event.end_time,
        title: event.title,
        url: event.url,
        allDay:event.all_day,
        realId: event.id,
        timetable_name: event.timetable_name
      }
      end

  end

  def add_to_calendar(events)
    begin
      my_events=self.calendar_events.create!(events)
    rescue ActiveRecord::RecordInvalid
      logger.info "#{my_events.first.errors.messages}\n"
      false
    end
  end

  def update_class_time(class_time)
    remove_timetable_events(class_time)
    add_to_calendar(class_time.build_calendar_for_user)
  end

  def remove_timetable_events(timetable)
    self.calendar_events.where(:event_group_id=>timetable.event_group_id).destroy_all
  end

  def my_courses
    course_versions=PaperTrail::Version.where(:whodunnit=>id.to_s,:item_type=>'Course')
    
    course_versions.inject([]) do |result,v|
        course=v.next.nil? ? Course.find(v.item_id) : v.next.reify
      result<<{
        title: course.title,
        date: v.created_at,
        event: v.event,
        id: v.item_id,
        lesson: course.lessons.first
      }
    end
   

  end

  def my_companies
    company_versions=PaperTrail::Version.where(:whodunnit=>id.to_s,:item_type=>'Company')
     company_versions.inject([]) do |result,v|
      result<<{
        name: v.next.nil? ? Company.find(v.item_id).name : v.next.reify.name,
        date: v.created_at,
        event: v.event,
        id: v.item_id
      }
    end
    

  end

  def as_json(option={})
    super(option.merge(:include=>[:members,:timetables],:methods=>[:friends_recent_comments,:friends_recent_posts,:friends_recent_post_comments]))
  end



  private
  def add_random_nickname

    candidate_nickname=nil
       begin
        candidate_nickname=authenticated_tokens.first.nil? ? 'user'+Random.rand(100000000).to_s : authenticated_tokens.first.provider.to_s+Random.rand(100000000).to_s
        found=User.where(:nickname=>candidate_nickname).first
       end while found
       self.nickname||=candidate_nickname
  end

  def add_registration_date
       self.registration_date=Time.now
  end

  

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end

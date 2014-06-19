class ShortMessage < ActiveRecord::Base
  attr_accessible :create_time, :media, :message, :message_group_id, :sender_id,:category
  has_many :receivers, :through=>:messengers,:class_name=>'User',:source=>:user
  has_many :messengers
  belongs_to :message_group

  belongs_to :sender,:class_name=>'User',:foreign_key=>:sender_id
  mount_uploader :media, MessageUploader
  validates_presence_of :message_group_id
  validate :media_cannot_be_null_when_it_set
  before_create :add_create_time,:add_receivers
  after_save :update_status
  CATEGORY={'文字'=>0,'图片'=>1,'声音'=>2}

  def self.find_by_group(group)
    where(:message_group_id=>group.id)
  end

  def self.find_by_group_range(group,start_param,end_param)
    where("short_messages.message_group_id=? and create_time>? and create_time <=?",group.id,start_param,end_param)
  end

  def self.send_system_message(user,message)
    system_user=User.where(:email=>'system@uesku.com').first
    group=MessageGroup.locate_users([user],system_user)
    begin
      self.create!({
        :message=>message,
        :message_group_id=>group.id,
        :sender_id=>system_user.id,
        :category=>0
        })
    rescue ActiveRecord::RecordInvalid
      logger.info "Error: system cannot send message to #{user.name}"
      false
    end

  end

  def is_sender?(user)
    self.sender==user

  end

  def as_json(option={})
    super(option.merge(:only=>[:id,:create_time, :media, :message, :message_group_id, :category],
                        :include=>{:sender=>{:only=>[:id,:name]}}))
  end


  private
    def media_cannot_be_null_when_it_set
      if self.category >0
        
         errors.add(:media, "media path can't be empty") if self.media.url.blank?

      end
    end
    
    def add_create_time
      self.create_time=Time.now
    end

    def update_status
      message_group.message_group_users.each do |item|
        item.new_message unless item.user.id==sender_id
      end
    end

    def add_receivers
      self.receivers=self.message_group.users-[self.sender]
    end

end

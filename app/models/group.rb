class Group < ActiveRecord::Base
  #attr_accessible :created_time, :owner_id, :lesson_id, :logo, :title,:locked,:description,:lessons
  has_many :group_lessons,:dependent=>:destroy
  has_many :lessons,:through=>:group_lessons
  has_many :posts,:dependent=>:destroy
  has_many :members,:dependent=>:destroy
  belongs_to :owner,:class_name=>'User',:foreign_key=>:owner_id
  has_many :users,:through =>:members
  mount_uploader :logo,AvatarUploader
  validates_presence_of :title,:description
  before_create :add_created_time
  after_create :owner_is_manager

  def lessons=(brs)
    brs.each do  |br|
      lesson=Lesson.find(br)
      self.lessons<<lesson unless self.lessons.index(lesson)
    end
    self.lessons.each do |lesson|
      self.lessons.delete(lesson) unless brs.index(lesson.id.to_s)
    end
  end

  def add_member(user)
   if self.locked
     self.members.create(:user_id=>user.id)
     false
   else
     self.members.create(:user_id=>user.id,:status=>'approval')
     true
   end
  end

  def member?(user_id)
    !(self.members.approval.where(:user_id=>user_id).empty?)
  end

  def manager?(user_id)
    !(self.members.managers.where(:user_id=>user_id).empty?)
  end



    private
    def owner_is_manager
      self.members.create(:user_id=>owner_id,:status=>'approval',:role=>'manager')
    end
    def add_created_time
      self.created_time=Time.now
    end
end

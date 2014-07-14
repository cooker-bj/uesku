#--*- encoding: UTF-8
class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,   :lockable,
          :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me,:name,:roles
   validates_presence_of :name
  ROLES={1=>'内容管理',2=>'类别管理',4=>'人员管理',8=>'社区管理'}
  # attr_accessible :title, :body
  def roles=(rs)
     write_attribute(:roles,rs.inject(0){|s,r|s+=r.to_i} )
  end

  def roles
    ro=[]
    myroles=read_attribute(:roles)
    ROLES.each do |key, value|
         ro<<value if myroles &key !=0
    end
     ro
  end

  def content_manager?
    evaluate_roles 1
  end

  def category_manager?
    evaluate_roles 2
  end

  def user_manager?
    evaluate_roles 4
  end

  def community_manager?
    evaluate_roles 7
  end

  def disactive
     self.in_active=false
    save
  end

  def active_for_authentication
    super &&  in_acitve
  end



  private

  def evaluate_roles(key)
   ! (read_attribute(:roles) & key==0)
  end




end

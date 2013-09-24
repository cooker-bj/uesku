class Member < ActiveRecord::Base
  attr_accessible :group_id, :user_id,:status,:role
  belongs_to :group
  belongs_to :user
  scope :managers, where(:role=>'manager')
  scope :approval, where(:status=>'approval')
  scope :pending, where(:status=>'pending')
  def set_as_manager
    self.role='manager'
    save
  end

  def approval_member
    self.status='approval'
    save
  end

  def withdraw_manager
    self.role="member"
    self.save
  end

  def is_manager?
    self.role=='manager'
  end

  def method_missing(method_id,*arguments,&block)
    if group.respond_to?(method_id)
      self.class.send :define_method,method_id do
        group.send(method_id,*arguments,&block)
      end

    elsif user.respond_to?(method_id)
      self.class.send :define_method,method_id do
        user.send(method_id,*arguments,&block)
      end
    else
      super
    end
    self.send(method_id,*arguments,&block)
  end
end

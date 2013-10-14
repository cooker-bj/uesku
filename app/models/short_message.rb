class ShortMessage < ActiveRecord::Base
  attr_accessible :create_time, :media, :message, :message_group_id, :sender_id,:read_status
  belongs_to :message_group

  belongs_to :sender,:class_name=>'User',:foreign_key=>:sender_id
  before_create :add_create_time


  def is_sender(user)
    self.sender==user

  end

  private
    def add_create_time
      self.create_time=Time.now
    end


end

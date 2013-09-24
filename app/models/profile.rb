class Profile < ActiveRecord::Base
  attr_accessible :address, :district_id, :phone, :resume, :user_id
  belongs_to :user
  belongs_to :location, :foreign_key=>:district_id

end

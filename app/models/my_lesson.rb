class MyLesson < ActiveRecord::Base
  attr_accessible :address, :age_range, :company, :create_time, :creator_id, :description, :free_try, :phone, :price, :special, :status, :title, :website
end

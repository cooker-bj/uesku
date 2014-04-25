class Picture < ActiveRecord::Base
  attr_accessible :creator_id, :has_picture, :has_picture_type, :image
  belongs_to :has_picture, :polymorphic => true
end

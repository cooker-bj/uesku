class Picture < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  #attr_accessible :creator_id, :has_picture_id, :has_picture_type, :image
  belongs_to :user,:foreign_key=>:creator_id
  belongs_to :has_picture, :polymorphic => true
  mount_uploader :image, ImageUploader
  
   def to_jq_upload
    {
      "name" => read_attribute(:image),
      "size" => image.size,
      "url" => image.url,
      "thumbnail_url" => image.thumb.url,
      "delete_url" => picture_path(:id => id),
      "delete_type" => "DELETE"
    }
  end

  def as_json(option={})
    json={
      "id" => id,
      "name" => read_attribute(:image),
      "size" => image.size,
      "url" => image.url,
      "thumbnail_url" => image.thumb.url,
      "delete_url" => picture_path(:id => id),
      "delete_type" => "DELETE"
    }
    json
  end

end

class Place < ActiveRecord::Base
  #attr_accessible :city_id, :description, :direction, :district_id, :opening_hours, :phone, :latitude, 
  #				  :longitude, :price, :province_id, :street, :title, :website,:pictures,:tag_list,:user_id
  belongs_to :province,:class_name=>'Location',:foreign_key=>'province_id'
  belongs_to :city, :class_name=>'Location',:foreign_key=>'city_id'
  belongs_to :district,:class_name=>'Location',:foreign_key=>'district_id'
  belongs_to :user
  has_many :pictures,:as=>:has_picture
  has_many :comments, :as =>:commentable
  has_many :ratings, :as=>:ratingable
  validates_presence_of :title,:street
  has_paper_trail
  acts_as_taggable

  def pictures=(args)
    args.each do |arg|
      picture=Picture.find(arg)
      self.pictures<<picture
    end
  end


   def address
        if province.name == city.name
          city.name+district.name+street
        else
          province.name+city.name+district.name+street
        end
    end

    def recount_rank
      self.rank=ratings.average('value')
      self.rank_count=ratings.count
      save!
    end
end

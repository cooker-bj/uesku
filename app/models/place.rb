class Place < ActiveRecord::Base
  attr_accessible :city_id, :description, :direction, :district_id, :opening_hours, :phone, :positionx, 
  				  :positiony, :price, :province_id, :recommendation, :street, :title, :website,:pictures
  belongs_to :province,:class_name=>'Location',:foreign_key=>'province_id'
  belongs_to :city, :class_name=>'Location',:foreign_key=>'city_id'
  belongs_to :district,:class_name=>'Location',:foreign_key=>'district_id'
  has_many :pictures,:as=>:has_picture
  
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
end

class Branch < ActiveRecord::Base
  attr_accessible :city_id, :district_id, :geolat, :geolng, :name, :phone, :province_id, :street, :website,:company_id
  belongs_to :company
  has_many :lessons,:dependent=>:destroy
  has_many :courses, :through=>:lessons
  belongs_to :province,:class_name=>'Location',:foreign_key=>'province_id'
  belongs_to :city,:class_name=>'Location',:foreign_key =>'city_id'
  belongs_to :district,:class_name=>'Location',:foreign_key =>'district_id'

      def address
        if province.name == city.name
          city.name+district.name+street
        else
          province.name+city.name+district.name+street
        end


      end
end

class Branch < ActiveRecord::Base
  #attr_accessible :city_id, :district_id, :geolat, :geolng, :name, :phone, :province_id, 
  #                :street, :website,:company_id,:company_attributes
  attr_accessor :is_changed
  belongs_to :company
  has_many :lessons,:dependent=>:destroy
  has_many :courses, :through=>:lessons
  belongs_to :province,:class_name=>'Location',:foreign_key=>'province_id'
  belongs_to :city,:class_name=>'Location',:foreign_key =>'city_id'
  belongs_to :district,:class_name=>'Location',:foreign_key =>'district_id'
  validates_presence_of :province_id,:city_id,:district_id,:name
  accepts_nested_attributes_for :company
  before_save :check_change
  after_save :trigger_company
  has_paper_trail

      def address
        if province.name == city.name
          city.name+district.name+street
        else
          province.name+city.name+district.name+street
        end


      end



      def as_json(option={})
       super(option.merge(:only=>[:geolat,:geolng,:name,:phone,:website]))
      end

    private
      def check_change
        is_changed=self.changed?
      end
      def trigger_company
        self.company.touch_for_version if self.is_changed
      end

end

class Location < ActiveRecord::Base
  attr_accessible :name
  has_ancestry
  has_many :branches,:foreign_key=>:district_id
  has_many :lessons, :through=>:branches,:foreign_key=>:district_id

  validates_presence_of :name
  def self.first_cities
    self.roots.nil? ||self.roots.first.nil? ? [] :self.roots.first.children()
  end

  def level
    case self.depth
      when 0 then {:roots=>true}
      when 1 then {:medium=>true}
      when 2 then {:leaves=>true}
    end
  end

  def self.first_districts
    self.first_cities.first.nil? ? [] :self.first_cities.first.children()
  end

def as_json(option={})
  super(option.merge(:only=>[:name,:id,:ancestry]))
end

end

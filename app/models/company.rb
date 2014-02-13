class Company < ActiveRecord::Base

  attr_accessible :description,  :name, :tags, :website,:branches_attributes
   has_many :branches
   has_many :courses
   has_many :lessons, :through=>:courses
   accepts_nested_attributes_for :branches,:allow_destroy=>true
  include AuditContent
   scope :published, where(:audit => true)
   validates_uniqueness_of :name
end

#--*--encoding: UTF-8
class Course < ActiveRecord::Base
  attr_accessible :title, :category_id, :company_id, :description, :price, :tags, :website,:free_try,:special,:age_range,:branches
  belongs_to :company
  belongs_to :category
  has_many :lessons,:dependent=>:destroy
  has_many :branches, :through => :lessons
  validates_presence_of :title
  include AuditContent
  AGE_RANGE=['0-6岁','7-12岁','13-18岁','成人',"无限制"]


  def branches=(brs)
       brs.each do  |br|
         branch=Branch.find(br)
         self.branches<<branch unless self.branches.index(branch)
       end
       self.branches.each do |branch|
         self.branches.delete(branch) unless brs.index(branch.id.to_s)
       end
  end

  def age_range
    AGE_RANGE[attribute(:age_range).to_i]
  end


end
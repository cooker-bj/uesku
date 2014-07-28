#--*--encoding: UTF-8
class Course < ActiveRecord::Base
  attr_accessible :title, :category_id, :company_id, :description, :price, :tags, :website,:free_try,:special,:age_range,:branches,:features_attributes
  belongs_to :company
  belongs_to :category
  has_many :lessons,:dependent=>:destroy
  has_many :branches, :through => :lessons
  has_many :features
  accepts_nested_attributes_for :features
  validates_presence_of :title
  has_paper_trail
  include AuditContent
  AGE_RANGE=['0-6岁','7-12岁','13-18岁','成人',"无限制"]
  after_create :renew_score
  after_update :renew_update_score

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

  private
  def renew_score
    User.find(self.originator).update_attributes(:score=>User.find(self.originator).score+10)
  end

  def renew_update_score
      User.find(self.originator).update_attributes(:score=>User.find(self.originator).score+5) 
  end
end
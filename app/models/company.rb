class Company < ActiveRecord::Base

  attr_accessible :description,  :name, :tags, :website,:branches_attributes
   has_many :branches
   has_many :courses
   has_many :lessons, :through=>:courses
   has_paper_trail
   accepts_nested_attributes_for :branches
   before_save :moniter_clients
  include AuditContent
   scope :published, where(:audit => true)
   validates_uniqueness_of :name

   

   def versioned_branches
     real_branches=[]

    if self.version.nil?
      real_branches=self.branches
    else
      created_time=self.version.previous.created_at
      #previous_created_time=self.version.previous.try(:created_at)
      p created_time
      self.branches.each do |br|
        branch_version=br.versions.where("created_at < ?",created_time).last
        p "version=#{branch_version}"
        unless branch_version.nil?
           branch= branch_version.next.nil? ? br : branch_version.next.reify
        
        real_branches<<branch 
        end
      end
    end
     real_branches
   end

   def get_version(arg)
   self.versions.find(arg).next.nil? ? self : self.versions.find(arg).next.reify
   end

   private
   def moniter_clients
    self.updated_at=Time.now if self.changed_for_autosave?
   end

end

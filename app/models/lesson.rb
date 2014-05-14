class Lesson < ActiveRecord::Base
  attr_accessible :branch_id, :course_id,  :rank, :rank_counter,:course_score,
                  :teacher_score,:security_score,:environment_score,:scores_attributes,:comments_attributes,
                  :course_attributes,:branch_attributes
  belongs_to :course
  belongs_to :branch
  has_one :company, :through=>:course
  has_many :recommendations,:dependent=>:destroy
  has_many :scores,:dependent=>:destroy
  has_many :comments, :as =>:commentable
  has_many :group_lessons,:dependent=>:destroy
  has_many :groups,:through=>:group_lessons
  has_many :timetables,:dependent=>:destroy
  accepts_nested_attributes_for :scores
  accepts_nested_attributes_for :comments, reject_if: proc{|attributes| attributes[:comment].blank?}
  accepts_nested_attributes_for :course
  accepts_nested_attributes_for :branch
  #include(AuditContent)
  #scope :published, where('lessons.audit=? ',true)
  #has_paper_trail


  def self.local_lessons(city_id)
  self.where("branches.city_id"=>city_id).joins(:branch)
  end




  def incity(city)
     self.where("branches.city_id=?",city).joins(:branch).order("rank desc")
  end

  def self.filter_with_category(cat)
    if cat.blank?
      scoped
    else
       where("courses.category_id"=>cat).joins(:course).order("rank desc")
    end
  end



  def self.filter_with_district(dist)
    if dist.blank?
       scoped
    else
      where("branches.district_id"=>dist).joins(:branch).order("rank desc")
    end
  end

   def find_user_score(user)
     self.scores.where(:user_id=>user.id).first unless user.nil?
   end

  def company_name
    company=self.course.company
    company.nil? ? "": company.name
  end

  def method_missing(method_id,*arguments,&block)
    if course.respond_to?(method_id)
      self.class.send :define_method,method_id do
        course.send(method_id,*arguments,&block)
      end

    elsif branch.respond_to?(method_id)
      self.class.send :define_method,method_id do
         branch.send(method_id,*arguments,&block)
      end
    else
      super
    end
      self.send(method_id,*arguments,&block)
  end


  def count_scores
    self.course_score=scores.average('course')
    self.environment_score=scores.average('environment')
    self.security_score=scores.average('security')
    self.teacher_score=scores.average('teacher')
    self.rank_counter=scores.count()
    self.rank=(course_score+environment_score+security_score+teacher_score)/4
    save!
  end

  def as_json(option={})
    super(option.merge(:except=>[:audit,:branch_id,:course_id],:methods=>[:company_name],
      :include=>{:course=>{:only=>[:title, :description, :price, :tags, :website,:free_try,:special,:age_range],
                           :include=>{:category=>{:only=>[:name]}}
                           },
                :branch=>{
                            :methods=>[:address],
                            :only=>[:geolat,:geolng,:name,:phone,:website],
                            :include=>{
                                        :company=>{:only=>[:description, :name, :tags, :website]}
                                      }
                          },
                :comments=>{},
                :groups=>{},
                :timetables=>{}
                }))
  end


  def versions
    cl=[]
    self.course.versions.reverse_each do |v|
      c_date=v.created_at
      d_date=v.next.try(:created_at)
      branch_versions=self.branch.versions.where(created_at: c_date ... (d_date.nil? ? Time.now : d_date))
      this_course= v.next.nil? ? self.course : v.next.reify
            

      cl<<{:course=>this_course,:branch=>self.branch} if branch_versions.blank?
      branch_versions.each do |bv|
        this_branch= bv.next.nil? ? self.branch : bv.next.reify
        cl<<{:course=>this_course,:branch=>this_branch}
      end
     
    end

    cl
  end

  def get_version(arg)
   pattern=/(\d*)_(\d*)/
   match_data=pattern.match(arg)

   course_version_id=match_data[1]
   branch_version_id=match_data[2]
  
   course=course_version_id.blank? ? self.course : self.course.versions[course_version_id.to_i].reify
   branch=branch_version_id.blank? ? self.branch :  self.branch.versions[branch_version_id.to_i].reify
   {:id=>self.id,:course=>course,:branch=>branch}
   
   
  end

end

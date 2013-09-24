class Lesson < ActiveRecord::Base
  attr_accessible :branch_id, :course_id,  :rank, :rank_counter,:course_score,:teacher_score,:security_score,:environment_score
  belongs_to :course
  belongs_to :branch
  has_one :company, :through=>:course
  has_many :recommendations
  has_many :scores
  has_many :comments
  has_many :group_lessons
  has_many :groups,:through=>:group_lessons
  include(AuditContent)
  scope :published, where('lessons.audit=? ',true)

  def self.local_lessons(city_id)
  self.published.where("branches.city_id"=>city_id).joins(:branch)
  end




  def incity(city)
     self.where("branches.city_id=?",city).joins(:branch).order("rank desc")
  end

  def self.filter_with_category(cat)
    if cat.nil?||cat.empty?

      self.where(true)
      else
       where("courses.category_id"=>cat).joins(:course).order("rank desc")
      end
  end



  def self.filter_with_district(dist)
    if dist.nil?||dist.empty?
       self.where(true)
    else
      where("branches.district_id"=>dist).joins(:branch).order("rank desc")
    end
  end

   def find_user_score(user)
     self.scores.where(:user_id=>user.id).first unless user.nil?
   end

  def company_name
    company=self.course.company
    company.nil? ? "":company.name
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

end

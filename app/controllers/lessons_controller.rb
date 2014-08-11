class LessonsController <ApplicationController
  before_filter :authenticate_user!, :except=>[:index,:show,:category,:district]
  layout :set_layout
  respond_to :html,:js

  def index
    @lessons=Lesson.local_lessons(get_city).filter_with_district(params[:district]).paginate(:page=>params[:page],:per_page=>20)
    @district=params[:district]|| []
    respond_with [@lessons,@district] do |format|
      format.html do |html|
        html.none {render 'category'}
        html.phone {render 'category'}
      end
      format.js {render 'add_items'}
    end
    
  end

  def company
    @course=Course.new(:company_id=>params[:company_id])
    respond_with @course
  end

  def course
    @course=Course.new(:company_id=>params[:company_id])
    respond_with @course

  end

  def edit
    @lesson=Lesson.find(params[:id])
    respond_with @lesson
  end

  def show
    @lesson=Lesson.find(params[:id])
    @score=@lesson.find_user_score(current_user) unless current_user.nil?
    @score||=Score.new
    respond_with [@lesson,@score]
  end

  def create
    @course=Course.new(course_params)
    @course.save
    respond_with @course,:location=>lesson_path(@course.lessons.first)
  end

  def update
    @lesson=Lesson.find(params[:id])
    @lesson.update_attributes(lesson_params)
    respond_with @lesson,:location=>lesson_path(@lesson)
  end

  def history
    @lesson=Lesson.find(params[:id])
    @history=@lesson.course.versions
    respond_with [@lesson,@history]
  end

  def compare
    @lesson=Lesson.find(params[:id])
    @current=@lesson.course.versions.find(params[:versions][0]).next.nil? ? @lesson.course : @lesson.course.versions.find(params[:versions][0]).next.reify
    @previous=@lesson.course.versions.find(params[:versions][1]).next.nil? ? @lesson.course : @lesson.course.versions.find(params[:versions][1]).next.reify
    respond_with [@lesson,@current,@previous]
  end

  def category
    @lessons=Category.find(params[:id]).local_lessons(get_city).filter_with_district(params[:district]).paginate(:page=>params[:page],:per_page=>20)
    @district=params[:district]|| []
    respond_with [@lessons,@district]
  end

  def district
    @lessons=Location.find(params[:id]).lessons.filter_with_category(params[:category]).paginate(:page=>params[:page],:per_page=>20)
    @category=params[:category]|| []
    respond_with [@lessons,@category]
  end

  def undo
    @lesson=Lesson.find(params[:id])
    @course=params[:version_id].nil? ? @lesson.course : @lesson.course.versions.find(params[:version_id]).reify
    respond_with [@lesson,@course]
  end
 
 
  private
  def course_params
    params.required(:course).permit(:title, :category_id, :company_id, :description, :price, :tags, :website,:free_try,:special,:age_range,:branches)
  end
  
  def lesson_params
    params.required(:lesson).permit(:branch_id, :course_id,  :rank, :rank_counter,:course_score,:teacher_score,:security_score,:environment_score,
                                    :scores_attributes=>[:course,:teacher,:security,:environment,:user_id,:id],
                                    :comments_attributes=>[:_destroy,:id,:comment, :comment_time, :user_id,:commentable,:commentable_type],
                                    :course_attributes=>[:_destroy,:id,:title, :category_id, :company_id, :description, :price, :tags, :website,:free_try,:special,:age_range],
                                    :branch_attributes=>[:_destroy,:id,:city_id, :district_id, :geolat, :geolng, :name, :phone, :province_id,:street, :website,:company_id])
  end
end
class LessonsController <ApplicationController
  before_filter :authenticate_user!, :except=>[:index,:show,:category,:district]
  respond_to :html

  def index
    @lessons=Lesson.local_lessons(get_city).filter_with_district(params[:district]).paginate(:page=>params[:page],:per_page=>20)
    @district=params[:district]|| []
    render 'category'
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
    @course=Course.new(params[:course])
    @course.save
    respond_with @course,:location=>lesson_path(@course.lessons.first)
  end

  def update
    @lesson=Lesson.find(params[:id])
    @lesson.update_attributes(params[:lesson])
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
 
end
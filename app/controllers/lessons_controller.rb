class LessonsController <ApplicationController
  respond_to :html, :json

  def index
    @lessons=Lesson.local_lessons(get_city).filter_with_district(params[:district]).paginate(:page=>params[:page],:per_page=>20)
    @district=params[:district]|| []
    render 'category'
  end

  def new
  end

  def edit
    @lesson=Lesson.find(params[:id])
    respond_with @lesson
  end

  def show
    @lesson=Lesson.published.find(params[:id])
    @score=@lesson.find_user_score(current_user) unless current_user.nil?
    @score||=Score.new
    respond_with [@lesson,@score]
  end

  def update
    @lesson=Lesson.find(params[:id])
    @lesson.update_attributes(params[:lesson])
    respond_with @lesson,:location=>lesson_path(@lesson)
  end

  def history
    @lesson=Lesson.find(params[:id])
  end

  def compare
    lesson=Lesson.find(params[:id])
    @current=lesson.versions[params[:versions][0]].reify.next_version;
    @previous=lesson.versions[params[:versions][1]].reify.next_version;
    respond_with [@current,@previous]
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

 
end
class LessonsController <ApplicationController
  respond_to :html, :json

  def index
    @lessons=Lesson.local_lessons(get_city).filter_with_district(params[:district]).paginate(:page=>params[:page],:per_page=>20)
    @district=params[:district]|| []
    render 'category'
  end

  def show
    @lesson=Lesson.published.find(params[:id])
    @score=@lesson.find_user_score(current_user) unless current_user.nil?
    @score||=Score.new
    respond_with @lesson
  end

  def category
    @lessons=Category.find(params[:id]).local_lessons(get_city).filter_with_district(params[:district]).paginate(:page=>params[:page],:per_page=>20)
    @district=params[:district]|| []
    respond_with @lessons
  end

  def location
    @lessons=Location.find(params[:id]).lessons
  end

  def comment
    @comments=Lesson.published.find(params[:id]).comments.order("comment_time DESC").paginate(:page=>params[:page],:per_page=>20)
    respond_with @comments, :layout=>false
  end

  def remove
    @comment=Comment.find(params[:id])
    @comment.destroy
    render :json=>{:success=>true}

  end
end
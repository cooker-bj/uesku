class LessonsController <ApplicationController
  respond_to :html, :json

  def show
    @lesson=Lesson.published.find(params[:id])
    @score=@lesson.find_user_score(current_user) unless current_user.nil?
    @score||=Score.new
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
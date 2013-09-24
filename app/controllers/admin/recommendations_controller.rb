class Admin::RecommendationsController <Admin::AdminBaseController
  respond_to :html,:json
  def index
    @lesson=Lesson.find(params[:lesson_id])
    @rec=@lesson.recommendations
  end

  def new
    @rec=Recommendation.new
    @rec.lesson_id=params[:lesson_id]
    @rec.city_id=Lesson.find(params[:lesson_id]).city_id
  end

  def create
    @rec=Recommendation.new(params[:recommendation])
    @rec.save
    respond_with @rec, :location=>admin_lesson_recommendations_path(@rec.lesson.id)
  end

  def destroy
    @rec=Recommendation.find(params[:id])
    @rec.destroy
    respond_with @rec, :location=>admin_lesson_recommendations_path(params[:lesson_id])
  end
end
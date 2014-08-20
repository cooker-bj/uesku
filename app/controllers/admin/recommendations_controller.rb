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

  def edit
    @rec=Recommendation.find(params[:id])
    respond_with @rec
  end

  def create
    @rec=Recommendation.new(recommendation_params)
    @rec.save
    respond_with @rec, :location=>admin_lesson_recommendations_path(@rec.lesson.id)
  end

  def update
    @rec=Recommendation.find(params[:id])
    @rec.update_attributes(recommendation_params)
    respond_with @rec, :location=>admin_lesson_recommendations_path(@rec.lesson.id)
  end

  def destroy
    @rec=Recommendation.find(params[:id])
    @rec.destroy
    respond_with @rec, :location=>admin_lesson_recommendations_path(params[:lesson_id])
  end
  
  private
  def recommendation_params
    params.required(:recommendation).permit(:lesson_id, :recommend_date,:position,:city_id,:image,:description,:image_cache)
  end
end
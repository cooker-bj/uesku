class ScoresController<ApplicationController
  before_filter :authenticate_user!
  def create
      @score=Score.new(score_params)
      @score.save
      redirect_to lesson_path(params[:lesson_id])
  end

  def update
    @score=Score.find(params[:id])
    @score.update_attributes(score_params)
    redirect_to lesson_path(params[:lesson_id])

  end

  def destroy

  end
  
  private
  def score_params
    params.required(:score).permit(:course, :environment, :lesson_id, :security, :teacher, :user_id)
  end
end
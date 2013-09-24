class ScoresController<ApplicationController
  before_filter :authenticate_user!
  def create
      @score=Score.new(params[:score])
      @score.save
      redirect_to lesson_path(params[:lesson_id])
  end

  def update
    @score=Score.find(params[:id])
    @score.update_attributes(params[:score])
    redirect_to lesson_path(params[:lesson_id])

  end

  def destroy

  end
end
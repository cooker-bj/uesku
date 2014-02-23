class MainController < ApplicationController
   respond_to :html,:json
  def index

  end

  def category
    @lessons=Category.find(params[:id]).local_lessons(get_city).filter_with_district(params[:district]).paginate(:page=>params[:page],:per_page=>20)
    @district=params[:district]|| []
    respond_with[@lessons,@district]

  end

  def location
    @lessons=Location.find(params[:id]).lessons
    respond_with @lessons
  end
end

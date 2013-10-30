class CoursesController < ApplicationController
  def index
  end

  def category
    @lessons=Category.find(params[:id]).local_lessons(get_city).filter_with_district(params[:district]).paginate(:page=>params[:page],:per_page=>20)
    @district=params[:district]|| []

  end

  def location
    @lessons=Location.find(params[:id]).lessons
  end
end

class CategoriesController < ApplicationController
	respond_to :json
  def index
  	@categories=Category.all
  	respond_with @categories
  end

  def course_select
    @cur=Category.find(params[:mid]).get_tree
    render :partial=>'course_select',:layout=>false,:locals=>{:cur=>@cur}
  end
end

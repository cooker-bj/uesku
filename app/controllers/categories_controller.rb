class CategoriesController < ApplicationController
	respond_to :json
  def index
  	@categories=Category.all
  	respond_with @categories
  end

  def subcategory
    @cur=Category.find(params[:mid]).children
    render :json=>@cur
  end
end

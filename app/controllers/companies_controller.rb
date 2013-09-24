class CompaniesController < ApplicationController

  def index
    @companies=Company.published.paginate :page=>params[:page],:per_page=>40
  end

  def show
    @company=Company.published.find(params[:id])
  end
end
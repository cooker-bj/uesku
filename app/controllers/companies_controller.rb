class CompaniesController < ApplicationController
	respond_to :html,:json

  def index
    @companies=Company.published.paginate :page=>params[:page],:per_page=>40
    respond_with @companies
  end

  def show
    @company=Company.published.find(params[:id])
    respond_with @company
  end
end
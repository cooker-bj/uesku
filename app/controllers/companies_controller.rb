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

  def new
  	@company=Company.new
  	@company.branches.build(:geolng=>116.31051333,:geolat=>39.95548177)
  	respond_with @company

  end

  def edit
  	@company=Company.find(params[:id])
  	respond_with @company
  end

  def create
  	@company=Company.new(params[:company])
  	@company.save
  	respond_with @company
  end

  def update
  	@company=Company.find(params[:id])
  	@company.update_attributes(params[:company])
  	respond_with @company
  end

  def select_company
  	@companies=Company.published.paginate :page=>params[:page],:per_page=>40
    respond_with @companies do |format|
    	format.html {render :partial=>'companies_partial',:layout=>false}
    end
  end

end
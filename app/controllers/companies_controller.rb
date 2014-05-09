class CompaniesController < ApplicationController
  before_filter :authenticate_user!, :except=>[:index,:show]
	respond_to :html

  def index
    @companies=Company.paginate :page=>params[:page],:per_page=>40
    respond_with @companies
  end

  def show
    @company=Company.find(params[:id])
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
  	@companies=Company.order('id DESC').paginate :page=>params[:page],:per_page=>40
    respond_with @companies do |format|
    	format.html {render :partial=>'companies_partial',:layout=>false}
    end
  end


  def history
    @company=Company.find(params[:id])
    @history=@company.versions
    respond_with [@company,@history]
  end


  def compare
    company=Company.find(params[:id])
    @current=company.get_version(params[:versions][0])
    @previous=company.get_version(params[:versions][1])
    respond_with [@current,@previous]
  end

  def undo
    company_object=Company.find(params[:id])
    @company=params[:version_id].nil? ? company_object : company_object.versions.find(params[:version_id]).reify
    render 'edit'
  end

end
class Admin::BranchesController <  Admin::AdminBaseController
  respond_to :html,:json

  def new
    @branch=Branch.new
    @branch.company_id=params[:company_id]
  end

  def edit
    @branch=Branch.find(params[:id])
  end

  def create
    @branch=Branch.new(params[:branch])
    @branch.save
    respond_with [:admin,@branch],:location=>admin_company_path(@branch.company)
  end

  def update
    @branch=Branch.find(params[:id])
    @branch.update_attributes(params[:branch])
    respond_with [:admin,@branch],:location=>admin_company_path(@branch.company)
  end

  def destroy
    @branch=Branch.find(params[:id])
    company=@branch.company
    @branch.destroy
   # respond_with [:admin,@branch],:location =>admin_company_path(company)
    respond_with [:admin,@branch] do |format|
      format.html do
        if request.xhr?
          render :json=>{:success=>true}
        else
          redirect_to [:admin,@branch]
        end
      end
      end
  end
end

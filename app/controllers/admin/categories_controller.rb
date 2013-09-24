#--*--encoding:UTF-8
class Admin::CategoriesController <  Admin::AdminBaseController
  respond_to :html,:json
  def index
    @categories=Category.roots
    respond_with [:admin,@categories]

  end


  def new
    @category=Category.new
    @option={}
    @option[:second]=Category.first_second_category
    @option[:select]={:roots=>true}
    respond_with [:admin,@category]
  end

  def edit

    @category=Category.find(params[:id])
    @option={:cur=>@category.root.id}
    @option={:second=>@category.root.children}
    @option[:select]=@category.level
    respond_with [:admin,@category]
  end

  def create
    @category=Category.new(params[:category])
    flash[:notice]="已保存" if @category.save
    respond_with [:admin,@category]
  end

  def update
    @category=Category.find(params[:id])
    flash[:notice]="已更新" if  @category.update_attributes(params[:category])
    respond_with [:admin,@category]
  end

  def show
    redirect_to :action=>'index'
  end

  def destroy
    @category=Category.find(params[:id])
    @category.destroy
    respond_with [:admin,@category]
  end

  def select
    @categories=Category.find(params[:mid]).children
    respond_with [:admin,@categories],:layout=>false
  end

  def course_select
    @cur=Category.find(params[:mid]).get_tree
    render :partial=>'course_select',:layout=>false,:locals=>{:cur=>@cur}
  end
end

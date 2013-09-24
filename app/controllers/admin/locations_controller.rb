#--*--encoding: UTF-8
class Admin::LocationsController <Admin::AdminBaseController
  respond_to :html,:json
  def index
    @locations=Location.roots
    respond_with [:admin,@locations]

  end


  def new
    @location=Location.new
    @option={}
    @option[:second]=Location.first_cities
    @option[:select]={:leaves=>true}
    respond_with [:admin,@location]
  end

  def edit

    @location=Location.find(params[:id])
    @option={:cur=>@location.root.id}
    @option={:second=>@location.root.children}
    @option[:select]=@location.level
    respond_with [:admin,@location]
  end

  def create
    @location=Location.new(params[:location])
    flash[:notice]="已保存" if @location.save
    respond_with [:admin,@location]
  end

  def update
    @location=Location.find(params[:id])
    flash[:notice]="已更新" if  @location.update_attributes(params[:location])
    respond_with [:admin,@location]
  end

  def show
    redirect_to :action=>'index'
  end

  def destroy
    @location=Location.find(params[:id])
    @location.destroy
    respond_with [:admin,@location]
  end

  def select
    @locations=Location.find(params[:mid]).children
    respond_with [:admin,@locations],:layout=>false
  end

end
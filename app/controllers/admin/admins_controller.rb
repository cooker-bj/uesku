#--encoding: UTF-8
class Admin::AdminsController < Admin::AdminBaseController

  respond_to :html,:json
 def index
   @users=Admin.all
   respond_with @user
 end

  def new
    @user=Admin.new
    respond_with @user
  end

  def edit
    @user=Admin.find(params[:id])
    respond_with @user
  end

  def show
    @user=Admin.find(params[:id])
    respond_with @user
  end

  def  create
    @user=Admin.new(params[:admin])
    flash[:notice]='已保存' if @user.save
    respond_with @user,:location=>admin_admin_path(@user)
  end

  def update
    @user=Admin.find(params[:id])
    if needs_password?(@user,params)
      @user.update_attributes(params[:admin])
    else
      params[:admin].delete(:current_password)
      @user.update_without_password(params[:admin])
    end

    respond_with @user,:location=>admin_admin_path(@user)
  end

  def destroy
    @user=Admin.find(params[:id])
    @user.disactive
    redirect_to :action=> 'index'

  end
  private
  def needs_password?(user,params)
     !params[:admin][:password].blank?
  end
end
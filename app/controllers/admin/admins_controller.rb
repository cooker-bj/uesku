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
    @user=Admin.new(admin_params)
    flash[:notice]='已保存' if @user.save
    respond_with @user,:location=>admin_admin_path(@user)
  end

  def update
    @user=Admin.find(params[:id])
    if needs_password?(@user,params)
      @user.update_attributes(admin_params)
    else
      params[:admin].delete(:current_password)
      @user.update_without_password(admin_params)
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
  
  def admin_params
    params.required(:admin).permit(:email, :password, :password_confirmation, :remember_me,:name,:roles)
  end
end
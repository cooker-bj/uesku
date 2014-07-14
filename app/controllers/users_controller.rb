class UsersController < ApplicationController
  before_filter :authenticate_user!
   respond_to :html
  def groups
    @user=User.find(params[:id])
    respond_with @user
  end

  def messenger
    @user=User.find(params[:id])
    respond_with @user

  end

  def show
    @user=current_user
   respond_with @user
  end

  def profile
    @user=User.find(params[:id])
    respond_with @user
  end
  
  def edit
    @user=current_user
  end
  
  def update_password
    @user=User.find(current_user.id)
    if @user.update_with_password(user_params)
      sign_in @user, :bypass=>true
      redirect_to root_user_path
    else
      render 'edit'
    end
  end
  
  private
    
  def user_params
    params.required(:user).permit(:password,:password_confirmation,:current_password)
  end
  

end
class UsersController < ApplicationController
  before_filter :authenticate_user!
   respond_to :html, :json
  def groups
    @user=User.find(params[:id])
  end

  def messenger
    @user=User.find(params[:id])


  end

  def show
    @user=current_user
   respond_with @user
  end

  def profile
    @user=User.find(params[:id])
    respond_with @user
  end
end
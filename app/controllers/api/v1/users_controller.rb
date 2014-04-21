class Api::V1::UsersController < ApiController
  
   respond_to :json
  def groups
    @groups=User.find(params[:id]).try(:groups)
    respond_with @user
  end

  def show
    @user=User.find(params[:id])
    if @user==current_user
     respond_with @user
    else
      respond_with @user.as_json({:only=>[:email,:registration_date,:points,:avatar],:method=>[:name]})
    end
  end
 

end
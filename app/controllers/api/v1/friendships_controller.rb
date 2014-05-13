class API::V1::FriendshipsController< ApiController
  
   respond_to :json
  def index
    @friends=current_user.my_friends
    @applied_friends=current_user.applied_friends
    @pending_friends=current_user.pending_friends
    respond_with[@friend,@applied_friends,@pending_friends]
  end


  def create
    @friendship=current_user.friendships.build(:friend_id=>params[:friend_id])
    if @friendship.save
      render :json=>{:success=>true,:friend=>@friendship.friend.name}
    else
      render :json=>@friendship.errors,:status=>:unprocessable_entity
    end
  end


  def destroy
    @friendship=current_user.inverse_friendships.where(:user_id=>params[:id]).first
    @friendship.destroy
    render :json=>{:success=>true}
  end



  def agree
    @friendship=Friendship.where(:user_id=>params[:id],:friend_id=>current_user.id).first
    @friendship.status=true
    if @friendship.save
      render :json=>{:success=>true}
    else
      render :json=>{:success=>false}
    end
  end

  def qurey_users
    if params[:argm]=~ /(\w+\.?)*@\w+\.\w+/
      @users=User.where(:email=>params[:argm])
    else
      @users=User.where('nickname= :args or (nickname is null and real_name= :args)',:args=>params[:argm])
    end
    render :json=>@users
  end
end
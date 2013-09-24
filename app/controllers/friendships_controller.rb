class FriendshipsController< ApplicationController
   before_filter :authenticate_user!
   respond_to :html,:json
  def create
  @friendship=current_user.friendships.unscoped.build(:friend_id=>params[:friend_id])
  if @friendship.save
  render :json=>{:success=>true,:friend=>@friendship.friend.name}
  else
    render :json=>@friendship.errors,:status=>:unprocessable_entity
  end
  end




def destroy
  @friendship=current_user.inverse_friendships.where(:user_id=>params[:id])
  @friendship.destroy
  render :json=>{:success=>true}
end

def agree
  @friendship=Friendship.where(:user_id=>params[:id],:friend_id=>current_user.id)

    @friendship.status=true
    @friendship.save

  render :json=>{:success=>true}
end



end
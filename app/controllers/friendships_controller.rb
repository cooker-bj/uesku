class FriendshipsController< ApplicationController
   before_filter :authenticate_user!
   respond_to :html,:json
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
  render :partial=>'users/friends', :locals=>{:user=>current_user},:layout=>false
end

def agree
  @friendship=Friendship.where(:user_id=>params[:id],:friend_id=>current_user.id).first

    @friendship.status=true
    @friendship.save

  render :partial=>'users/friends', :locals=>{:user=>current_user},:layout=>false
end



end
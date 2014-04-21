class Api::V1::ShortMessagesController < ApiController
  
  respond_to :json
  def index
    @groups=current_user.message_groups
    respond_with @groups
  end

  def show
    @group=MessageGroup.get_messages(params[:id],current_user)
    @messages=@group.messages
    respond_with [@group,@messages]
  end

  def new_message
    @group=MessageGroup.locate_users(params[:users],current_user)
    @messages=[]
    respond_with [@group,@messages] 
  end

  def create
    @message=ShortMessage.new(params[:short_message])
    respond_with @message 
  end

  def show_messages
    @group=MessageGroup.find(params[:id])
    respond_with @group 
  end

  def new_messages
    group=MessageGroup.find(params[:id])
    @messages=current_user.read_new_messages(group)
    respond_with [@group,@messages] 
  end

  def manage
    @group=MessageGroup.find(params[:id])
    respond_with @group 
  end

  def add_users
    @group=MessageGroup.find(params[:id])
    @group.add_users(params[:users])
    render :json=>{:success=>true}
  end

  def remove_users
    @group=MessageGroup.find(params[:id])
    @group.remove_users(params[:users])
    render :json=>{:success=>false}
  end

  def destroy
    @group=MessageGroup.find(params[:id])
    @group.remove_users([current_user.id])
    render :json=>{:success=>true}
  end
end

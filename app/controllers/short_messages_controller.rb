class ShortMessagesController < ApplicationController
  def index
    @groups=current_user.message_groups
  end

  def show
    @group=MessageGroup.get_messages(params[:id],current_user)
    @messages=@group.messages
    render :partial=> 'show',:layout=>false;
  end

  def new_message
    @group=MessageGroup.locate_users(params[:users],current_user)
    render :partial=>'show',:layout=>false
  end

  def create
    @message=ShortMessage.new(params[:short_message])
    if @message.save
      render :partial=>'messages',:layout=>false,:locals=>{:messages=>@message.message_group.messages}
    else
      render :json=>{:success=>false,:error=>@message.errors}
    end
  end

  def show_messages
    @group=MessageGroup.find(params[:id])
    render :partial=>'messages',:locals=>{:messages=>@group.messages},:layout=>false
  end

  def manage
    @group=MessageGroup.find(params[:id])
    render :partial=>'manage',:layout=>false
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
    @group.destroy
    redirect_to 'index'
  end
end

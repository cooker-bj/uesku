class ShortMessagesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html,:json
  def index
    @groups=current_user.message_groups
    respond_with @groups
  end

  def show
    @group=MessageGroup.get_messages(params[:id],current_user)
    @messages=@group.messages
    respond_with [@group,@messages] do |format|
      format.html do 
        render :partial=> 'show',:layout=>false 
      end
    end
  end

  def new_message
    @group=MessageGroup.locate_users(params[:users],current_user)
    @messages=[]
    respond_with [@group,@messages] do |format|
      format.html do  
        render :partial=>'show',:layout=>false 
      end
    end
  end

  def create
    @message=ShortMessage.new(params[:short_message])
    @message.sender_id=current_user.id
    respond_with @message do |format|
      if @message.save
        format.html do 
          render :partial=>'messages',:layout=>false,:locals=>{:messages=>[@message]} 
        end
      else
        render :json=>{:success=>false,:error=>@message.errors}
      end
    end
  end

  def show_messages
    @group=MessageGroup.find(params[:id])
    respond_with @group do |format|
      format.html do 
        render :partial=>'messages',:locals=>{:messages=>@group.messages},:layout=>false 
      end
    end
  end

  def new_messages
    group=MessageGroup.find(params[:id])
    @messages=current_user.read_new_messages(group)
    respond_with [@group,@messages] do |format|
      format.html do  
        render :partial=>'messages',:locals=>{:messages=>@messages},:layout=>false 
      end
    end
  end

  def manage
    @group=MessageGroup.find(params[:id])
    respond_with @group do |format|
      format.html do 
        render :partial=>'manage',:layout=>false 
      end
    end
  end

  def add_users
    @group=MessageGroup.find(params[:id])
    @group.add_users(params[:users])
    render :json=>{:success=>true}
  end

  def remove_users
    @group=MessageGroup.find(params[:id])
    @group.remove_users(params[:users])
    render :json=>{:success=>true}
  end

  def destroy
    @group=MessageGroup.find(params[:id])
    @group.remove_users([current_user.id])
    respond_with @group do |format|
      format.html do 
        redirect_to 'index'
      end
      format.json do 
        render :json=>{:success=>true}
      end
    end
  end
end

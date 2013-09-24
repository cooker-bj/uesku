class MessengersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html,:json
  def index
    @messengers = Messenger.my_messages(current_user)


  end

  # GET /messengers/1
  # GET /messengers/1.json
  def show
    @messenger = Messenger.find(params[:id])
    @messenger.has_read
    respond_with @messenger
  end

  # GET /messengers/new
  # GET /messengers/new.json
  def new
    @messenger = Messenger.new
    @messenger.sender_id=current_user
    @messenger.receiver=params[:receiver_id]
    respond_with @messenger
  end




  # POST /messengers
  # POST /messengers.json
  def create
    @messenger = Messenger.new(params[:messenger])

        if @messenger.save
        flash[:notice]="消息已发出"
        respond_with @messenger
    end
  end

  # PUT /messengers/1
  # PUT /messengers/1.json


  # DELETE /messengers/1
  # DELETE /messengers/1.json
  def destroy
    @messenger = Messenger.find(params[:id])
    @messenger.destroy

    respond_with @messenger
  end

  def new_messages
    @messenger_count=Messenger.new_messages_count(current_user)
  end
end

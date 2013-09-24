class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @conversation=Conversation.find(params[:id])
  end
end
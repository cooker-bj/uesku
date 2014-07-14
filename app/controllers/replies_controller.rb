class RepliesController < ApplicationController
  before_filter :authenticate_user!
   respond_to :html
  def create
     @reply=Reply.new(reply_params)
    if @reply.save
      respond_with @reply do |format|
        format.html do
          if request.xhr?
            render :partial=>'show',:layout=>false,:status=>:created,:locals=>{:reply=>@reply}
          else
            redirect_to @reply
          end

        end
      end
    else
      respond_with @reply do |format|
        format.html do
          if request.xhr?
            render :json=>@reply.errors,:status=>:unprocessable_entity
          else
            render :action=>'new',:status=>:unprocessable_entity
          end

        end
      end

    end
  end



  def destroy
    @reply=Reply.find(params[:id])
    @reply.destroy
   render :json=>{:success=>true}
  end
  
  private
  def reply_params
    params.required(:reply).permit(:comment_id, :message, :reply_time, :user_id)
  end
end
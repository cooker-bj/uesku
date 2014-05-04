class CommentsController < ApplicationController
	before_filter :authenticate_user!, :except=>[:index]
	respond_to :html

	def index
		@commentable=find_commentable
		@comments=@commentable.comments.order('comment_time DESC').paginate(:page=>params[:page],:per_page=>20)
				respond_with [@commentable,@comments],:layout=>false
	end


	def  edit
		@comment=Comment.find(params[:id])
		respond_with @comment,:layout=>false
	end

	def create
		@commentable=find_commentable
	    @comment=@commentable.comments.build(params[:comment])
	    @comment.user_id=current_user.id
	    if  @comment.save
	    	render :json=>{:success=>true}
	    else
	    	render :json=>{:errors=>@comment.errors,:status=>:unprocessable_entity}
	    end

	end

	def update
		@comment=Comment.find(params[:id])
         if @comment.update_attributes(params[:comment])
		 	render :json=>{:success=>true}
		 else
		 	render :json=>{:errors=>@comment.errors,:status=>:unprocessable_entity}
		 end
	end

	def destroy
		@comment=Comment.find(params[:id])
		@comment.destroy
		render :json=>{:success=>true}
	end

	private

	def find_commentable
		params.each do |name, value|
			if name=~/(.+)_id$/
				return $1.classify.constantize.find(value)
			end
		end
		nil
	end
end

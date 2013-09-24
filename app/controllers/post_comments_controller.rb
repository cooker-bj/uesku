#encoding: UTF-8
class PostCommentsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html,:json
   def index
     @post_comments=PostComment.all
   end

  # GET /post_comments/1
  # GET /post_comments/1.json
  def show
    @post_comment = PostComment.find(params[:id])


  end

  # GET /post_comments/new
  # GET /post_comments/new.json
  def new
    @post_comment = PostComment.new


  end

  # GET /post_comments/1/edit
  def edit
    @post_comment = PostComment.find(params[:id])

    respond_with @post_comment,:layout=>false
  end

  # POST /post_comments
  # POST /post_comments.json
  def create
    @post_comment = PostComment.new(params[:post_comment])
    flash[:notice]="已保存" if @post_comment.save

    redirect_to :controller=>'posts',:action=>'show',:id=>@post_comment.post_id

  end

  # PUT /post_comments/1
  # PUT /post_comments/1.json
  def update
    @post_comment = PostComment.find(params[:id])

      respond_with @post_comment do |format|
        if @post_comment.update_attributes(params[:post_comment])
        format.html {render :partial=>'comment',:locals=>{:comment=>@post_comment},:status=>200,:layout=>false}
        else
        format.html { render :json=>@post_comment.errors,:status=>:unprocessable_entity}
        end
      end


  end

  # DELETE /post_comments/1
  # DELETE /post_comments/1.json
  def destroy
    @post_comment = PostComment.find(params[:id])
    @post_comment.destroy

    render :json=>{:success=>true}
  end
end

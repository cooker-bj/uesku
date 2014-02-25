#encoding: UTF-8
class PostsController < ApplicationController
  before_filter :authenticate_user!
 respond_to :html,:json
  def index
    @posts = Post.group_posts_list(params[:group_id]).paginate(:page=>params[:page],:per_page=>20)

   respond_with @posts,:layout=>false
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comments=@post.post_comments.paginate(:page=>params[:page],:per_page=>20)
   respond_with [@post,@comments]
  end

  # GET /posts/new
  # GET /posts/new.json

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    respond_with @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
  flash[:notice]='已提交' if @post.save
     respond_with @post

end



  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])


    flash[:notice]="已更新"  if @post.update_attributes(params[:post])
    respond_with @post
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])

    respond_with do |format|
      if  @post.destroy

        format.html do
          if request.xhr?
            render :json=>{:success=>true}
          end
        end
      else
        format.html do
          if request.xhr?
            render :json=>{:success=>false}
          end
        end
      end

    end

  end

  def set_to_top
    @post=Post.find(params[:id])

    respond_with do |format|
      if  @post.set_top

        format.html do
          if request.xhr?
            render :json=>{:success=>true}
          end
        end
      else
        format.html do
          if request.xhr?
            render :json=>{:success=>false}
          end
        end
      end

    end
  end

  def withdraw_to_top
    @post=Post.find(params[:id])
    respond_with do |format|
      if  @post.withdraw_to_top

     format.html do
       if request.xhr?
         render :json=>{:success=>true}
       end
     end
      else
        format.html do
          if request.xhr?
            render :json=>{:success=>false}
          end
        end
     end

   end
  end

  def set_to_distillate
    @post=Post.find(params[:id])

    respond_with do |format|
      if   @post.set_distillate

        format.html do
          if request.xhr?
            render :json=>{:success=>true}
          end
        end
      else
        format.html do
          if request.xhr?
            render :json=>{:success=>false}
          end
        end
      end

    end
  end

  def withdraw_distillate
    @post=Post.find(params[:id])

    respond_with do |format|
      if  @post.withdraw_distillate

        format.html do
          if request.xhr?
            render :json=>{:success=>true}
          end
        end
      else
        format.html do
          if request.xhr?
            render :json=>{:success=>false}
          end
        end
      end

    end
  end

 end
#encoding: UTF-8
class PostsController < ApplicationController
  before_filter :authenticate_user!
 respond_to :html
 respond_to :js, :only=>['index']
 layout :set_layout
  def index
    @posts = Post.group_posts_list(params[:group_id]).paginate(:page=>params[:page],:per_page=>20)

   respond_with @posts,:layout=>false
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    
   respond_with @post
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new(group_id: params[:group_id])
    respond_with @post
  end
  
  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    respond_with @post, :layout=>false
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.poster=current_user
    @post.group_id||=params[:group_id]
    if @post.save
      render :json=>{:url=>post_path(@post)}
    else
      render :json=>{:errors=>@post.errors,:status=>:unprocessable_entity}
    end

  end



  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:notice]=t(:update_message) 
      render :json=>{:success=>true}
    else
      render :json=>{:errors=>@post.errors,:status=>:unprocessable_entity}
    end
    
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
  
  private
  
  def post_params
    params.required(:post).permit( :posted_time, :poster_id, :title,:group_id,:content)
  end

 end
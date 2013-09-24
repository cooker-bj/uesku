#encoding: UTF-8
class GroupsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html,:json
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.paginate :page=>params[:page],:per_page=>40

   respond_with @group
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])
    @posts=@group.posts
   respond_with @group do |format|
     format.html do


        if @group.member?(current_user.id)
          render 'show'
        elsif @group.locked?
          render 'about'
        else
          render 'preview'
        end
     end
   end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new

    @group = Group.new
    @group.lessons<<Lesson.find(params[:lesson_id])
    @group.owner_id=current_user.id
    respond_with @group
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
    respond_with @group
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])
     flash[:notice]="班级已创建" if @group.save
    respond_with @group

  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])


      flash[:notice]="班级信息已修改" if @group.update_attributes(params[:group])
     respond_with @group
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_with @group
  end

  def add_member
    @group=Group.find(params[:id])
    if @group.add_member(current_user)
    respond_with @group
    else
    redirect_to groups_user_path(current_user.id)
    end

  end

   def administration
     @group=Group.find(params[:id])
     respond_with @group
   end

  def approval_member
     @group=Group.find(params[:id])
     member=Member.find(params[:member])
     member.approval_member
    render :partial=>'pending_members',:layout=>false
  end

  def reject_member
    @group=Group.find(params[:id])
    member=Member.find(params[:member])
    member.destroy
    render :partial=>'pending_members',:layout=>false
  end

  def  set_manager
    @group=Group.find(params[:id])
    member=Member.find(params[:member])
    member.set_as_manager
    render :partial=>'managers',:layout=>false
  end

  def withdraw_manager
    @group=Group.find(params[:id])
    member=Member.find(params[:member])
    member.withdraw_manager
    render :partial=>'managers',:layout=>false
  end
end

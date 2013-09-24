#--encoding: UTF-8
class QueryController < ApplicationController

  def group_member_for_management
    group=Group.find(params[:group_id])
    name=params[:user_name]
    @members=group.members.approval.joins(:user).where("real_name=? or nickname=?",name,name)

    render :partial=>'group_member_for_management',:layout=>false




  end
  # To change this template use File | Settings | File Templates.
end
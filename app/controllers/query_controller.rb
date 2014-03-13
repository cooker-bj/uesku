#--encoding: UTF-8
class QueryController < ApplicationController
	respond_to :html,:json

  def group_member_for_management
    group=Group.find(params[:group_id])
    name=params[:user_name]
    @members=group.members.approval.joins(:user).where("real_name=? or nickname=?",name,name)

    render :partial=>'group_member_for_management',:layout=>false
  end
  

  def query_companies
  	@companies=Company.where('name like ?','%'+params[:name]+'%')
    respond_to do |format|

  		format.html {render :partial=>'/companies/query_select_company',:layout=>false}
  		format.json {render json: @companies}
  	end
  end

  def query_companies_auto

    companies=Company.where('name like ?','%'+params[:term]+'%')
    @result=companies.inject([]){|ary,company| ary<<company.name}
    render :json=>@result
  end


end
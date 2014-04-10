class LocationsController < ApplicationController
	before_filter :authenticate_user!
	respond_to :json
  def index
  	@location=Location.all
  	respond_with @location

  end

   def select
    @locations=Location.find(params[:mid]).children.order('id')
    render :json=>@locations
  end
end

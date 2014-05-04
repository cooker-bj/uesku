class LocationsController < ApplicationController
	
	respond_to :html
  def index
  	@locations=Location.all
  	respond_with @locations
  end

   def select
    @locations=Location.find(params[:mid]).children.order('id')
    render :json=>@locations
   end

  def set_city
    location=Location.find(params[:id])
    set_city_in_session(location)
    redirect_to '/'
  end
end

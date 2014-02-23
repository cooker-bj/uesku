class LocationsController < ApplicationController
	respond_to :json
  def index
  	@location=Location.all
  	respond_with @location

  end
end

class CitiesController < ApplicationController
  def show
    @city=Location.find(params[:id])

  end
end

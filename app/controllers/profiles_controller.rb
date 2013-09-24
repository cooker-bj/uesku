class ProfilesController < ApplicationController
   respond_to :html,:json
  def new
    @profile=Profile.new
  end

  def edit
    @profile=Profile.find(params[:id])
  end

  def create
    @profile=Profile.new(params[:profile])
    @profile.save
    respond_with @profile
  end

  def update
    @profile=Profile.find(params[:id])
    @profile.update_attributes(params[:profile])
    respond_with @profile
  end

  def show
    @profile=Profile.find(params[:id])
  end
end

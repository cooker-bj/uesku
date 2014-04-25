class PlacesController < ApplicationController
  # GET /places
  # GET /places.json
  respond_to :html
  before_filter :authenticate_user!, :except=>[:index,:show]
  def index
    @places = Place.all

    respond_with  @places 
  end

  # GET /places/1
  # GET /places/1.json
  def show
    @place = Place.find(params[:id])

    respond_with @place
      
    
  end

  # GET /places/new
  # GET /places/new.json
  def new
    @place = Place.new

   respond_with @place
  end

  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(params[:place])
     @place.save
    respond_with @place
     
  end

  # PUT /places/1
  # PUT /places/1.json
  def update
    @place = Place.find(params[:id])
     @place.update_attributes(params[:place])
     respond_with @place
      
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    respond_with @place
  end
end

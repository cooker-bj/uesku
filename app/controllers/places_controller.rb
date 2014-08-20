class PlacesController < ApplicationController
  # GET /places
  # GET /places.json
  respond_to :html
  before_filter :authenticate_user!, :except=>[:index,:show]
  def index
    if params[:tag]
      @places=Place.tagged_with(params[:tag])
    else
      @places = Place.all
    end

    respond_with  @places 
  end

  # GET /places/1
  # GET /places/1.json
  def show
    @place = Place.find(params[:id])
    @rating=@place.ratings.where(:user_id=>current_user.id).first

    respond_with [@place,@rating]
      
    
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
    @place = Place.new(place_params)
    @place.user_id=current_user.id
     @place.save
    respond_with @place
     
  end

  # PUT /places/1
  # PUT /places/1.json
  def update
    @place = Place.find(params[:id])
    @place.update_attributes(place_params)
    respond_with @place
      
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    respond_with @place
  end
  
  private
  def place_params
    params.required(:place).permit(:city_id, :description, :direction, :district_id, :opening_hours, :phone, :latitude,:longitude, :price, :province_id, :street, :title, :website,:pictures,:tag_list,:user_id)
  end
end

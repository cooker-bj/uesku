class PicturesController < ApplicationController
  respond_to :json,:html
  def index
    @pictures=Picture.where(:has_picture_id=>params[:id],:has_picture_type=>params[:class_name].classify)
    
    respond_with @pictures 
   end


  def show
    @picture=Picture.find(params[:id])
    respond_with @picture
  end

  def create
     @picture = Picture.new(params[:picture])
     @picture.creator_id=current_user.id
    if @picture.save
      respond_with do |format|
        format.html {  
          render :json => {:files=>[@picture]}, 
          :content_type => 'text/html',
          :layout => false
        }
        format.json {  
          render :json => {files: [@picture]}           
        }
      end
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end

  end

  def destroy
    @picture=Picture.find(params[:id])
    @picture.destroy
    respond_with @picture
  end
end

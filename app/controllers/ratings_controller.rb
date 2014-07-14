class RatingsController < ApplicationController
	before_filter :authenticate_user!
     
     def index
     	ratingable=find_ratingable
     	@rating=ratingable.ratings.where(:user_id=>current_user.id).first
     	render :json=>@rating

	end

	def create
		@ratingable=find_ratingable
	    @rating=@ratingable.ratings.build(rating_params)
	    @rating.user_id=current_user.id
	    if  @rating.save
	    	render :json=>{:success=>true,:id=>@rating.id}
	    else
	    	render :json=>{:errors=>@rating.errors,:status=>:unprocessable_entity}
	    end

	end

	def update
		@rating=Rating.find(params[:id])
         if @rating.update_attributes(rating_params)
		 	render :json=>{:success=>true}
		 else
		 	render :json=>{:errors=>@rating.errors,:status=>:unprocessable_entity}
		 end
	end
private

	def find_ratingable
		params.each do |name, value|
			if name=~/(.+)_id$/
				return $1.classify.constantize.find(value)
			end
		end
		nil
	end
  
  def rating_params
    params.required(:rating).permit(:ratingable_id, :ratingable_type, :user_id, :value)
  end

end

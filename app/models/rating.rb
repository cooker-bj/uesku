class Rating < ActiveRecord::Base
  #attr_accessible :ratingable_id, :ratingable_type, :user_id, :value
  belongs_to :ratingable,:polymorphic=>true
  belongs_to :user
  after_save :renew_rank

  private
  def renew_rank
  	if ratingable.respond_to?(:recount_rank)
  		ratingable.recount_rank
  	end
  end

end

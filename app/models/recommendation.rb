#--*-- encoding: UTF-8
class Recommendation < ActiveRecord::Base
  attr_accessible :lesson_id, :recommend_date,:position,:city_id,:image,:description
  belongs_to :lesson
  before_save :add_recommendation_time
  mount_uploader :image,ImageUploader
  POSITION={'F1'=>'首页主推荐','F2'=>'首页其它推荐'}

  def self.get_list(pid,cid)
  where(:position=>pid,:city_id=>cid).order("recommend_date desc").limit(3)
  end


  private
  def add_recommendation_time
    self.recommend_date=Time.now
  end
end

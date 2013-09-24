class AddCityIdToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :city_id, :integer
  end
end

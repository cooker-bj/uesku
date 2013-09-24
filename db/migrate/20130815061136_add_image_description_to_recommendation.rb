class AddImageDescriptionToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :image, :string
    add_column :recommendations, :description, :string
  end
end

class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :lesson_id
      t.string :position
      t.datetime :recommend_date

      t.timestamps
    end
  end
end

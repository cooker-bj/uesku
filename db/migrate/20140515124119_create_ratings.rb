class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :value
      t.string :ratingable_type
      t.integer :ratingable_id

      t.timestamps
    end
  end
end

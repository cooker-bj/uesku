class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.integer :poster_id
      t.datetime :posted_time

      t.integer :group_id
      t.timestamps
    end
  end
end

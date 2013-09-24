class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
      t.integer :user_id
      t.datetime :comment_time
      t.text :message
      t.integer :post_id

      t.timestamps
    end
  end
end

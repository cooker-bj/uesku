class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment
      t.datetime :comment_time
      t.integer :user_id
      t.integer :lesson_id

      t.timestamps
    end
  end
end

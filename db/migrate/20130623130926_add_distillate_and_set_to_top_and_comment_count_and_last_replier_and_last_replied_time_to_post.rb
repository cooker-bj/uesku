class AddDistillateAndSetToTopAndCommentCountAndLastReplierAndLastRepliedTimeToPost < ActiveRecord::Migration
  def change
    add_column :posts, :distillate, :boolean,:null=>false,:default=>false
    add_column :posts, :set_to_top, :integer,:null=>false,:default=>0
    add_column :posts, :comment_count, :integer,:null=>false,:default=>-1
    add_column :posts, :last_replier_id, :integer
    add_column :posts, :last_replied_time, :datetime
  end
end

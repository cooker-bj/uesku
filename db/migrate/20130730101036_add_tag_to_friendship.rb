class AddTagToFriendship < ActiveRecord::Migration
  def change
    add_column :friendships, :tag, :integer,:null=>false,:default=>0

  end
end

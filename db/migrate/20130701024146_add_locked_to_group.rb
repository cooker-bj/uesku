class AddLockedToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :locked, :boolean,:null=>false,:default=>false
  end
end

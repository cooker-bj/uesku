class AlertComment < ActiveRecord::Migration
  def change
  	rename_column :comments, :commentable,:commentable_id
  end
end

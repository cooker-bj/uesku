class AddScoreIdToComment < ActiveRecord::Migration
  def change
    add_column :comments, :score_id, :integer
  end
end

class AddRankAndRankCountToPlace < ActiveRecord::Migration
  def change
    add_column :places, :rank, :decimal,:null=>false,:default=>0.0,:precision=>2,:scale=>1
    add_column :places, :rank_count, :integer,:null=>false,:default=>0
  end
end

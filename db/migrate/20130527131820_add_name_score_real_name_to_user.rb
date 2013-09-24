class AddNameScoreRealNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :score, :integer,:null=>false,:default=>0
    add_column :users, :real_name, :string
  end
end

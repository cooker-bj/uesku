class AddInActiveAndNameRolesToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :in_active, :boolean ,:null=>false,:default=>true
    add_column :admins, :name, :string
    add_column :admins, :roles, :integer, :null=>false, :default=>0
  end
end

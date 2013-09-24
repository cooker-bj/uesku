class AddRoleToMember < ActiveRecord::Migration
  def change
    add_column :members, :role, :string,:null=>false,:default=>'member'
  end
end

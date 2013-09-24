class AddStatusToMember < ActiveRecord::Migration
  def change
    add_column :members, :status, :string,:null=>false,:default=>'pending'
  end
end

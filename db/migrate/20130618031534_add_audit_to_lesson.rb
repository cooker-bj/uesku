class AddAuditToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :audit, :boolean,:null=>false,:default=>false
  end
end

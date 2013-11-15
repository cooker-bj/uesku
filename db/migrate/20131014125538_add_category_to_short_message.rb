class AddCategoryToShortMessage < ActiveRecord::Migration
  def change
    add_column :short_messages, :category, :integer,:null=>false,:default=>0
  end
end

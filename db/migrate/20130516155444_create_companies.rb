class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :website
      t.string :tags
      t.text :description
      t.string :image
      t.boolean :audit, :null=>false,  :default=>false
      t.timestamps
    end
  end
end

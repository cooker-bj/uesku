class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name
      t.string :phone
      t.string :website
      t.integer :province_id, :null=>false
      t.integer :city_id, :null=>false
      t.integer :district_id, :null=>false
      t.string :street
      t.string :geolng
      t.string :geolat

      t.timestamps
    end
  end
end

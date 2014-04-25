class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :title
      t.string :street
      t.integer :province_id
      t.integer :city_id
      t.integer :district_id
      t.string :website
      t.text :description
      t.text :recommendation
      t.string :price
      t.string :opening_hours
      t.string :positionx
      t.string :positiony
      t.string :direction
      t.string :phone

      t.timestamps
    end
  end
end

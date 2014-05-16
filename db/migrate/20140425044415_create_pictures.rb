class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :image
      t.integer :creator_id
      t.string :has_picture_type
      t.integer :has_picture_id

      t.timestamps
    end
  end
end

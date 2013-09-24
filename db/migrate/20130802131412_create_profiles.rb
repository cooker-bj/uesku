class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.text :resume
      t.string :address
      t.string :phone
      t.integer :district_id

      t.timestamps
    end
  end
end

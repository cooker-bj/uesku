class CreateMyLessons < ActiveRecord::Migration
  def change
    create_table :my_lessons do |t|
      t.string :title
      t.decimal :price
      t.string :age_range
      t.string :special
      t.boolean :free_try
      t.string :company
      t.string :address
      t.text :description
      t.string :website
      t.string :phone
      t.datetime :create_time
      t.integer :creator_id
      t.string :status,:null=>false,:default=>'pending'

      t.timestamps
    end
  end
end

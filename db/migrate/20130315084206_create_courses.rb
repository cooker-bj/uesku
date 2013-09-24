class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|

      t.string :title, :null =>false

      t.string :age_range

      t.integer :category_id,:null=>false
      t.float :price
      t.text :description

      t.string :tags

      t.string :website

      t.boolean :free_try,:null=>false,:default=>false
      t.integer :company_id, :null=>false

      t.string :special

      t.integer :creator_id
      t.integer :auditor_id
      t.boolean :audit, :null=>false,:default=>false
      t.timestamps
    end
  end
end

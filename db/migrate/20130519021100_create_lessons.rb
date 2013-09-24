class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.integer :course_id,:null=>false

      t.integer :branch_id,:null=>false

      t.decimal :rank,:null=>false,:default=>0.0,:precision=>2,:scale=>1

      t.integer :rank_counter,:null=>false,:default=>0


      t.timestamps
    end
  end
end

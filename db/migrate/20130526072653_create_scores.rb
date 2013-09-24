class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :security,:null=>false, :default=>0
      t.integer :teacher,   :null=>false, :default=>0
      t.integer :course, :null=>false, :default=>0
      t.integer :environment, :null=>false, :default=>0
      t.integer :user_id
      t.integer :lesson_id

      t.timestamps
    end
  end
end

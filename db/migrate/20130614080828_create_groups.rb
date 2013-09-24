class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.integer :owner_id
      t.datetime :created_time
      t.integer :lesson_id
      t.string :logo

      t.timestamps
    end
  end
end

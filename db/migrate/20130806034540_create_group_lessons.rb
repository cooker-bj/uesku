class CreateGroupLessons < ActiveRecord::Migration
  def change
    create_table :group_lessons do |t|
      t.integer :group_id
      t.integer :lesson_id

      t.timestamps
    end
  end
end

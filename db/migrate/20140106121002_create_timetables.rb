class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.integer :creator_id
      t.string :title
      t.text :description
      t.integer :lesson_id
      t.date :start_day
      t.date :end_day
      t.datetime :create_time

      t.timestamps
    end
  end
end

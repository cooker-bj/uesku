class CreateClassTimes < ActiveRecord::Migration
  def change
    create_table :class_times do |t|
      t.integer :timetable_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end

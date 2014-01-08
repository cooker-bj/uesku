class CreateClassTimes < ActiveRecord::Migration
  def change
    create_table :class_times do |t|
      t.integer :timetable_id
      t.datetime :start_day
      t.datetime :end_day
      t.integer :week
      t.string :start_time_hour
      t.string :start_time_minute
      t.string :end_time_hour
      t.string :end_time_minute
      t.string :name

      t.timestamps
    end
  end
end

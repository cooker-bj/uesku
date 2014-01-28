class AddTimetableNameToCalendarEvents < ActiveRecord::Migration
  def change
    add_column :calendar_events, :timetable_name, :string
  end
end

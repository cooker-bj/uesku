class AddAllDayToCalendarEvent < ActiveRecord::Migration
  def change
    add_column :calendar_events, :all_day, :boolean,:null=>false,:default=>false
  end
end

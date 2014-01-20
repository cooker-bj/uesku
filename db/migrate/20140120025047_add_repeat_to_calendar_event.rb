class AddRepeatToCalendarEvent < ActiveRecord::Migration
  def change
  	 add_column :calendar_events, :repeat, :boolean,:null=>false,:default=>false
  end
end

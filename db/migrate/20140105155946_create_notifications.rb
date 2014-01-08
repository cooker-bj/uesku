class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :calendar_event_id
      t.integer :alert_before_event,:null=>false,:default=>15

      t.timestamps
    end
  end
end

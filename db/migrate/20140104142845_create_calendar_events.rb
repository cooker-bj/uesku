class CreateCalendarEvents < ActiveRecord::Migration
  def change
    create_table :calendar_events do |t|
      t.integer :user_id
      t.string :title,:null=>false
      t.datetime :start_time,:null=>false
      t.datetime :end_time,:null=>false
      t.string :location
      t.text :description
      t.integer :notify1,:null=>false,:default=>60
      t.integer :notify2
      t.string :event_group_id
      t.string :source, :null=>false,:default=>'self'

      t.timestamps
    end
  end
end

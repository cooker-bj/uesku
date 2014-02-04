class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :calendar_event_id
      t.integer :alert_before_event,:null=>false,:default=>15
      t.string :when_to_alert,:null=>false,:default=>'start'

      t.timestamps
    end
  end
end

class CreateMessageGroups < ActiveRecord::Migration
  def change
    create_table :message_groups do |t|

      t.integer :creator_id
      t.datetime :create_time
      t.datetime :update_time
      t.timestamps
    end
  end
end

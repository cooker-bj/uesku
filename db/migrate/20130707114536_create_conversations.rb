class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :low_user_id
      t.integer :high_user_id
      t.integer :unread_messages_number,:null=>false,:default=>0
      t.datetime :new_message_time

      t.timestamps
    end
  end
end

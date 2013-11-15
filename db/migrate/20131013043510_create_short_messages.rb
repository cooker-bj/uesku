class CreateShortMessages < ActiveRecord::Migration
  def change
    create_table :short_messages do |t|
      t.datetime :create_time
      t.string :message
      t.string :media
      t.boolean :read_status,:null=>false,:default=>false
      t.integer :sender_id
      t.integer :message_group_id

      t.timestamps
    end
  end
end

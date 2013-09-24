class CreateMessengers < ActiveRecord::Migration
  def change
    create_table :messengers do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :conversation_id
      t.string :message
      t.boolean :read_status,:null=>false,:default=>false
      t.datetime :create_time

      t.timestamps
    end
  end
end

class CreateMessengers < ActiveRecord::Migration
  def change
    create_table :messengers do |t|
      t.integer :user_id
      t.integer :message_group_id
      t.integer :short_message_id
      t.boolean :read_status, :null=>false, :default=>false
      t.timestamps
    end
  end
end

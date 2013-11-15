class CreateMessageGroupUsers < ActiveRecord::Migration
  def change
    create_table :message_group_users do |t|
      t.integer :message_group_id
      t.integer :user_id
      t.boolean :has_new_messages, :null=>false, :default=>true
      t.timestamps
    end
  end
end

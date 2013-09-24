class CreateAuthenticatedTokens < ActiveRecord::Migration
  def change
    create_table :authenticated_tokens do |t|
      t.string :user_id
      t.string :provider
      t.string :uid
      t.string :access_token

      t.timestamps
    end
  end
end

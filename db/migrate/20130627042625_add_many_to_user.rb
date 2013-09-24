class AddManyToUser < ActiveRecord::Migration
  def change

    add_column :users, :nickname, :string

    add_column :users, :gender, :string
    add_column :users, :birthday, :date
    add_column :users, :avatar, :string
  end
end

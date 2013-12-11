class AddRegistrationDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :registration_date, :datetime
  end
end

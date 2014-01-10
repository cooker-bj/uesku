class CreateTakenClasses < ActiveRecord::Migration
  def change
    create_table :taken_classes do |t|
      t.integer :user_id
      t.integer :timetable_id

      t.timestamps
    end
  end
end

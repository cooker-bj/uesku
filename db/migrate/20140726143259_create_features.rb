class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.integer :course_id
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end

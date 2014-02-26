class ModifyComment < ActiveRecord::Migration
	def change
		change_table :comments do |t|
			t.remove :score_id,:lesson_id
			t.integer :commentable
			t.string :commentable_type

		end

		
	end
end
  

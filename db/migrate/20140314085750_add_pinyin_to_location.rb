class AddPinyinToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :pinyin, :string
  end
end

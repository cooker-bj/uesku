class Category < ActiveRecord::Base
  #attr_accessible :name,:parent_id
   has_ancestry
  validates_presence_of :name
  has_many :courses
  has_many :lessons,:through=>:courses
 def self.first_second_category
    self.roots.nil? ||self.roots.first.nil? ? [] :self.roots.first.children()
 end

  def local_lessons(local)

     self.lessons.local_lessons(local)
  end


  def level
    case self.depth
      when 0 then {:roots=>true}
      when 1 then {:medium=>true}
      when 2 then {:leaves=>true}
    end
  end

  def self.first_category
   self.first_second_category.first.nil? ? [] :self.first_second_category.first.children()
  end

   def get_tree
     treelist=path()

     if has_children?
       treelist<<(m=children.first)
       treelist<<m.children.first if m.has_children?
     end
     treelist
   end

   def as_json(option={})
    super(option.merge(:only=>[:name,:id,:ancestry]))
   end
end

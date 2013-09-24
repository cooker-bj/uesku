class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Admin.new # guest user (not logged in)

    if user.content_manager?
      can :manage,[Lesson,Company,Course,Branch,Recommendation]
      can :read, [Location,Category]
    end
   if user.category_manager?
        can :manage, [Location,Category]
        can :read, [Lesson,Company,Course,Branch]
    end
    if user.user_manager?
         can :manage, Admin
         can :read, [Lesson,Company,Course,Branch,Location,Category]

    end
  end



end
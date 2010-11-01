class Ability
  include CanCan::Ability
  
  def initialize(user)
    if user.nil?
      can :read, :all
    else
      if user.role? :admin
        can :manage, :all
      else
        can :read, :all
        if user.role?(:user)
          can :create, Article
        end
      end
    end
  end
  
end
class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new()
    if user.role? :admin
      can :manage, :all
    else
      can :read, :all
    end
    if user.role?(:user)
      can :create, Article
      can :update, Article do |article|
        article.try(:user) == user
      end
      
      can :update, User do |theuser|
        theuser.id == user.id
      end
    end

  end
  
end
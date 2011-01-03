class Ability
  include CanCan::Ability
  
  def initialize(user)
    if user.nil?
      can :read, :all
      can :search, Article
    else
      if user.role? :admin
        can :manage, :all
      else
        can :read, :all
        if user.role?(:user)
          can :create_comment, Article
          can :create, Comment
          can :create, Vote
          can :create, Article
          can :update, user
        end
      end
    end
  end
  
end
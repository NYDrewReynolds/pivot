class Ability

  include CanCan::Ability

  def initialize( user )
    user ||= User.new(role: nil)

    if user.is? :admin
      can :manage, Item, restaurant_id: user.restaurant.id
      can :manage, Category, restaurant_id: user.restaurant.id
      can :manage, Order
      can :manage, User, restaurant_id: user.restaurant.id
    elsif user.is? :user
      can :read, Item
      can :read, Category
      can :create, Order
      can :read, Order
      can :manage, User, id: user.id
    else
      can :read, Item
      can :read, Category
      can :create, User
    end
  end
end

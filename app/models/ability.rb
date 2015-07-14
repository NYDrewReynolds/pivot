class Ability

  include CanCan::Ability

  def initialize( user )
    user ||= User.new(role: nil)
    restaurant ||= Restaurant.find_by(owner_id: user.id)

    if user.is? :admin
      can :manage, Item, restaurant_id: restaurant.id
      can :manage, Category, restaurant_id: restaurant.id
      can :manage, Order, restaurant_id: restaurant.id
      can :manage, User, id: user.id
      can :read, Item
      can :read, Category
      can :read, Order
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

class Ability

  include CanCan::Ability

  def initialize( user )
    user ||= User.new(role: nil)

    if user.is? :admin
      can :manage, Item, restaurant_id: @owned_restaurant.id
      can :manage, Category, restaurant_id: @owned_restaurant.id
      can :manage, Order, restaurant_id: @owned_restaurant.id
      can :manage, User, User.restaurants.where(restaurant_id: @owned_restaurant.id)
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

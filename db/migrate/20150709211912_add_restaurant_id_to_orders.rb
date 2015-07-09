class AddRestaurantIdToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :restaurant, index: true, foreign_key: true
  end
end

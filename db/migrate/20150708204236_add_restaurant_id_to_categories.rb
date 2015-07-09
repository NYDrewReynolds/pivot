class AddRestaurantIdToCategories < ActiveRecord::Migration
  def change
    add_reference :categories, :restaurant, index: true
  end
end

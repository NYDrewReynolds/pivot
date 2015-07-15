class RenameUserRestaurants < ActiveRecord::Migration
  def change
    rename_table :user_restaurants, :user_staff_roles
  end
end

class AddStaffRoleToUserRestaurants < ActiveRecord::Migration
  def change
    add_reference :user_restaurants, :staff_role, index: true, foreign_key: true
  end
end

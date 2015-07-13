class CreateUserRestaurants < ActiveRecord::Migration
  def change
    create_table :user_restaurants do |t|
      t.references :restaurant, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end

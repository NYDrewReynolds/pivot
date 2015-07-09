class AddSlugNameToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :slug_name, :string
    add_index :restaurants, :slug_name, unique: true
  end
end

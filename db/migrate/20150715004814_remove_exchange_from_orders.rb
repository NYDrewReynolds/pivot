class RemoveExchangeFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :exchange
  end
end

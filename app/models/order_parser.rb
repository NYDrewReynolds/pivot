class OrderParser
  def parse(cart, current_user, order_params)
    restaurant_items = cart.items.map{ |item_id| Item.find(item_id) }.group_by{ |item| item.restaurant }

    restaurant_items.each do |restaurant, items|
      order = restaurant.orders.new(order_params)
      item_quantities_hash = to_quantities(items)
      item_quantities_hash.each do |item, quantity|
        quantity.times { order.items << item }
      end
      order.user = current_user
      save_order(order)
    end
  end

  def save_order(order)
    order.save!
  end

  def to_quantities(items)
    items.group_by { |item| item }
    .map { |item, items| [item, items.size] }.to_h
  end
end

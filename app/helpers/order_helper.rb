module OrderHelper

  def order_price(items)
    total = 0
    items.each do |item|
      total += item.price
    end
    total
  end

  def custom_format(time)
    to_datetime(time)
  end

  def order_button_display(order)

    display = order_statuses[order.status][0]
    next_status = order_statuses[order.status][1]


    link_to display, restaurant_admin_order_status_path(owned_restaurant, @order.id, next_status), method: :PATCH, remote: true, class: 'btn btn-grey3 status-button'
  end

  def order_statuses
    {   'ordered' => ['Mark as Paid', 'ready_for_prep'],
        'ready_for_prep' => ['Mark as Preparing', 'in_progress'],
        'in_progress' => ['Mark as Ready for Delivery', 'ready_for_delivery'],
        'ready_for_delivery' => ['Mark as Out for Delivery', 'out_for_delivery'],
        'out_for_delivery' => ['Mark as Completed', 'completed']
    }
  end

end

class Cart
  include ItemQuantity

  attr_reader :items

  def initialize(items)
    @items = Array(items).map(&:to_i)
  end

  def add_item(item_id, quantity)
    items.concat [item_id.to_i] * quantity.to_i
  end

  def to_a
    items
  end

  def size
    items.size
  end

  def delete(item_id)
    items.delete item_id.to_i
  end

  def update_quantity(item_id, quantity)
    delete item_id
    add_item(item_id, quantity)
  end

  def clear
    items.clear
  end

  def total
    prices = []
    items.map { |item_id| prices << Item.find(item_id).price.to_i }
    prices.reduce(:+)
  end

end

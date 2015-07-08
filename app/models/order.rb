class Order < ActiveRecord::Base
  include US
  include ItemQuantity

  belongs_to :user
  has_many :line_items
  has_many :items, through: :line_items

  validates :items, presence: true, on: :create
  validates :user, presence: true
  validates :status, inclusion: { in: :statuses }
  validates :exchange, inclusion: { in: :exchanges }
  validates :street_number,
            :street,
            :city,
            presence: true, if: :delivery?
  validates :state, inclusion: states, if: :delivery?
  validates :zip, format: { with: /\A\d{5}\d*\z/ }, if: :delivery?

  def delivery?
    exchange == 'delivery'
  end

  def statuses
    ['ordered', 'completed', 'cancelled', 'paid']
  end

  def exchanges
    ['pickup', 'delivery']
  end

  def add_item(item_id)
    self.items << Item.find(item_id)
  end

  def update_quantity(item_id, quantity)
    self.items.delete(item_id)
    quantity.to_i.times { add_item(item_id) }
  end

  def populate(cart, current_user)
    cart.item_ids_to_quantities.to_h.each do |item, quantity|
      quantity.times { self.items << item }
    end

	  self.user = current_user
  end
end

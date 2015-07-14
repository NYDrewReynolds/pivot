class Order < ActiveRecord::Base
  include US
  include ItemQuantity
  include AASM

  belongs_to :restaurant
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

  aasm :column => :status do
    state :ordered, :initial => true
    state :ready_for_prep
    state :cancelled
    state :in_progress
    state :ready_for_delivery
    state :out_for_delivery
    state :completed

    event :pay do
      transitions from: :ordered, to: :ready_for_prep
    end

    event :preparing do
      transitions from: :ready_for_prep, to: :in_progress
    end

    event :cooked do
      transitions from: :in_progress, to: :ready_for_delivery
    end

    event :out do
      transitions from: :ready_for_delivery, to: :out_for_delivery
    end

    event :delivered do
      transitions from: :out_for_delivery, to: :completed
    end

    event :cancel do
      transitions from: [:ordered, :ready_for_prep], to: :cancelled
    end
  end

  def delivery?
    exchange == 'delivery'
  end

  def statuses
    ['ordered', 'ready_for_prep', 'in_progress', 'ready_for_delivery', 'out_for_delivery' 'completed', 'cancelled']
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

end

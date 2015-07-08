class Category < ActiveRecord::Base
  validates :title, presence: true
  has_many :item_categories
  has_many :items, through: :item_categories
  belongs_to :restaurant

  def to_s
    title.tr('& ', 'n_')
  end
end

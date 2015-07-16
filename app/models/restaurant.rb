class Restaurant < ActiveRecord::Base
  extend FriendlyId
  has_many :orders
  has_many :items
  has_many :categories
  has_many :user_staff_roles
  has_many :users, through: :user_staff_roles
  before_save :set_slug

  friendly_id :slug_candidates, use: :slugged

  validates :name, uniqueness: true, presence: true
  validates :cuisine, presence: true

  def slug_candidates
    [:slug_name, :name]
  end

  def should_generate_new_friendly_id?
    slug_name_changed? || super
  end

  def set_slug
    self.slug_name = self.name unless self.slug_name
  end

end

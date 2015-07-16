class Restaurant < ActiveRecord::Base
  extend FriendlyId
  has_many :orders
  has_many :items
  has_many :categories
  has_many :user_staff_roles
  has_many :users, through: :user_staff_roles
  before_validation :set_slug_name

  friendly_id :slug_name, use: :slugged

  validates :name, uniqueness: true, presence: true
  validates :cuisine, presence: true

  def should_generate_new_friendly_id?
    slug_name_changed? || super
  end

  def set_slug_name
    self.slug_name = self.name.parameterize if self.slug_name.empty?
  end

end

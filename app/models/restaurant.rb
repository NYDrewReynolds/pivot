class Restaurant < ActiveRecord::Base
  extend FriendlyId
  has_many :users
  has_many :items
  has_many :categories
  friendly_id :slug_candidates, use: :slugged

  validates :name, uniqueness: true, presence: true
  validates :cuisine, presence: true

  def slug_candidates
    [:slug_name,
     :name]
  end

  def should_generate_new_friendly_id?
    slug_name_changed? || super
  end
end

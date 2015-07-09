class Restaurant < ActiveRecord::Base
  has_many :users
  has_many :items
  has_many :categories

  validates :name, uniqueness: true, presence: true
  validates :cuisine, presence: true
end

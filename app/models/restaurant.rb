class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_many :categories

  validates :name, uniqueness: true, presence: true
  validates :cuisine, presence: true
end

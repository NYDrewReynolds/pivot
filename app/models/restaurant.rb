class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_many :categories
end

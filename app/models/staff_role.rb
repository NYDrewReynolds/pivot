class StaffRole < ActiveRecord::Base
  has_many :user_staff_roles
  has_many :users, through: :user_staff_roles
end

class UserStaffRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant
  belongs_to :staff_role
end

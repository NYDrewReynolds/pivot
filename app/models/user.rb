class User < ActiveRecord::Base

  has_many :user_staff_roles
  has_many :restaurants, through: :user_staff_roles
  has_many :orders
  has_many :staff_roles, through: :user_staff_roles

  has_secure_password

  validate :first_and_last_names_cannot_both_be_blank
  validates :nickname, length: { in: 2..32, allow_nil: true }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  Roles = [ :admin , :user, :nonauth ]

  def first_and_last_names_cannot_both_be_blank
    if first_name.empty? && last_name.empty?
      errors.add(:full_name, "can't be blank")
    end
  end

  def full_name
    "#{first_name + ' ' + last_name}".strip
  end

  def is?( requested_role )
    self.role.to_s == requested_role.to_s || self.staff_roles.pluck(:name).include?(requested_role.to_s)
  end

  def ordered_items
    self.orders.map do |order|
      order.items.map do |item|
        item.title
      end
    end.flatten
  end

  def invite_lookup
  invite = Invite.find_by(email: email)
    if invite
      user_staff_roles.create(restaurant_id: invite.restaurant_id, staff_role_id: invite.staff_role_id)
      invite.destroy
    end
  end

end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    email "MyString"
    restaurant_id 1
    staff_role_id 1
    token "MyString"
  end
end

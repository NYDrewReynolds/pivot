FactoryGirl.define do
  factory :order do
    association :user
    items { [build(:item)] }
    status "ordered"
    street_number "123"
    street "Sesame St"
    city "Wall"
    state "GU"
    zip "80120"
  end
end

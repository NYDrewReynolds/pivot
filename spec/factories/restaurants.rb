FactoryGirl.define do
  sequence(:name) { |n| "#{n}" }

  factory :restaurant do
    name { generate(:name) }
    cuisine { generate(:cuisine) }
  end
end

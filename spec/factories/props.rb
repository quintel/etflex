FactoryGirl.define do
  factory :prop do
    sequence(:behaviour) { |n| "co#{n}-emissions" }
    key                  { behaviour.underscore  }
  end
end

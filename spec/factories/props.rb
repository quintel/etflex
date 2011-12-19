FactoryGirl.define do
  factory :prop do
    sequence(:client_key) { |n| "co#{n}-emissions" }
    key                   { client_key.underscore  }
  end
end

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :input do
    sequence(:remote_id)
    key { "factory_input_#{remote_id}" }
  end
end

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :scenario do
    sequence    :session_id

    association :scene
    association :user
  end
end

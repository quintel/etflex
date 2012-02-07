# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :scenario do
    sequence     :session_id

    query_results score: 500

    association  :scene
    association  :user
  end

  factory :guest_scenario, class: Scenario do
    sequence     :session_id
    query_results score: 500
    association  :scene
    guest_uid    'abc'
  end
end

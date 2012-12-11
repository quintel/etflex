# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:session_id) { |n| n }

  factory :scenario do
    session_id  { FactoryGirl.generate(:session_id) }

    query_results etflex_score: 500

    association  :scene
    association  :user
  end

  factory :guest_scenario, class: Scenario do
    session_id  { FactoryGirl.generate(:session_id) }
    query_results etflex_score: 500
    association  :scene
    guest_uid    'abc'
    guest_name   'def'
  end
end

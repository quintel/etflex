# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:session_id) { |n| n }

  factory :scenario do
   association  :scene
   association  :user

   session_id  { FactoryGirl.generate(:session_id) }

    query_results etflex_score: 500

  end

  factory :guest_scenario, class: Scenario do
    association  :scene

    session_id  { FactoryGirl.generate(:session_id) }
    query_results etflex_score: 500
    guest_uid    'abc'
    guest_name   'def'
  end
end

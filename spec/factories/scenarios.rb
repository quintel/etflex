# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryBot.define do
  sequence(:session_id) { |n| n }

  factory :scenario do
    association  :scene
    association  :user

    session_id { FactoryBot.generate(:session_id) }
    end_year   { 2030 }

    query_results { { 'etflex_score' => { 'present' => 0, 'future' => 500 } } }
  end

  factory :guest_scenario, class: Scenario do
    association :scene

    session_id { FactoryBot.generate(:session_id) }
    query_results { { 'etflex_score': { 'present' => 0, 'future' => 500 } } }
    guest_uid   { 'abc' }
    guest_name  { 'def' }
    end_year    { 2030 }
  end
end

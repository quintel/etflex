# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :input do
    sequence(:remote_id) do |remote_id|
      # Add 10_000 to the remote ID since this should prevent conflicting
      # with manually-set remote IDs on the occasions that we need to use
      # real-world remote IDs (such as in integration tests).
      remote_id + 10_000
    end

    key { "factory_input_#{remote_id}" }

    factory :mwh_input do
      unit      'mwh'
      min     10_000
      max    100_000
      start   50_000
      step       100
    end # :mwh_input
  end # :input

  factory :scene_input do
    association :input, factory: :mwh_input
  end
end

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :input do
    sequence(:remote_id)
    key { "factory_input_#{remote_id}" }

    factory :mwh_input do
      unit      'mwh'
      min     10_000
      max    100_000
      start   50_000
      step       100
    end # :mwh_input

  end # :input
end

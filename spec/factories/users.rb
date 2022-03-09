# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "etflex.#{ i }@example.com" }

    password               { 'abcdefghij' }
    password_confirmation  { 'abcdefghij' }

    factory(:admin) { admin { true } }
  end
end

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "etflex.#{ i }@example.com" }

    password               'mypassword'
    password_confirmation  'mypassword'

    factory(:admin) { admin true }
  end
end

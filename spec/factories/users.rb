FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:username) { |n| "username#{n}" }
    password { "secret" }
  end
end

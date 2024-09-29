FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:username) { |n| "username#{n}" }
    password { "secret" }

    trait :with_session do
      after(:create) do |user|
        create :session, user: user
      end
    end
  end
end

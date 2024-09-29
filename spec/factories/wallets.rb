FactoryBot.define do
  factory :wallet do
    for_user

    trait :with_balance do
      transient do
        balance { 999 }
      end

      after(:create) do |wallet, context|
        create :transaction, :credit, source_wallet: wallet, amount: context.balance
      end
    end

    trait :for_user do
      association :walletable, factory: :user
    end

    trait :for_team do
      association :walletable, factory: :team
    end
  end
end

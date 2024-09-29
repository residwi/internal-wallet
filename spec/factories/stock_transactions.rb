FactoryBot.define do
  factory :stock_transaction do
    source_wallet { association :wallet, :for_user }
    stock_name { "AAPL" }
    quantity { 1 }
    price { "9.99" }
  end
end

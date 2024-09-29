require "rails_helper"

RSpec.describe StockTransaction, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:source_wallet).class_name("Wallet") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:source_wallet) }
    it { is_expected.to validate_presence_of(:stock_name) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }
  end

  describe ".buy!" do
    it "creates a new StockTransaction and reduces the wallet balance" do
      wallet = create :wallet, :for_user, :with_balance, balance: 1000
      stock_name = "HDFCBANK"
      quantity = 3
      stock_price = 300

      StockTransaction.buy!(source_wallet_id: wallet.id, stock_name: stock_name, quantity: quantity, stock_price: stock_price)

      expect(wallet.balance).to eq(1000 - quantity * stock_price)
    end
  end
end

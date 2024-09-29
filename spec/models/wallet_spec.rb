require "rails_helper"

RSpec.describe Wallet, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:walletable) }
    it { is_expected.to have_many(:transactions).with_foreign_key("source_wallet_id") }
  end

  describe "#balance" do
    it "returns the correct balance" do
      wallet = create :wallet
      create :transaction, :credit, source_wallet: wallet, amount: 100
      create :transaction, :debit, source_wallet: wallet, amount: 50
      create :transaction, :credit, source_wallet: wallet, amount: 100

      expect(wallet.balance).to eq(150)
    end
  end
end

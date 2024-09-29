require "rails_helper"

RSpec.describe Transaction, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:source_wallet).class_name("Wallet") }
    it { is_expected.to belong_to(:target_wallet).class_name("Wallet").optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:source_wallet) }
    it { is_expected.to validate_presence_of(:target_wallet).on(:transfer) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe ".transfer!" do
    let(:source_wallet) { create :wallet, :for_user, :with_balance, balance: 100 }
    let(:target_wallet) { create :wallet, :for_user, :with_balance, balance: 100 }

    context "when the source wallet has sufficient funds" do
      it "transfers the amount from the source wallet to the target wallet" do
        Transaction.transfer!(source_wallet_id: source_wallet.id, target_wallet_id: target_wallet.id, amount: 50)

        expect(source_wallet.balance).to eq(50)
        expect(target_wallet.balance).to eq(150)
      end
    end

    context "when the source wallet does not have sufficient funds" do
      it "raises an error" do
        expect {
          Transaction.transfer!(source_wallet_id: source_wallet.id, target_wallet_id: target_wallet.id, amount: 200)
        }.to raise_error(ActiveRecord::RecordInvalid, /Insufficient balance/)
      end
    end
  end
end

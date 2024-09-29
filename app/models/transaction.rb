class Transaction < ApplicationRecord
  enum :transaction_type, { credit: "credit", debit: "debit" }, validate: true

  belongs_to :source_wallet, class_name: "Wallet", foreign_key: "source_wallet_id"
  belongs_to :target_wallet, class_name: "Wallet", foreign_key: "target_wallet_id", optional: true

  validates :source_wallet, presence: true
  validates :target_wallet, presence: true, on: :transfer
  validates :amount, numericality: { greater_than: 0 }

  validate :sufficient_funds, on: [ :transfer, :withdraw, :buy ]

  def self.transfer!(source_wallet_id:, target_wallet_id:, amount:)
    ActiveRecord::Base.transaction do
      source_wallet = Wallet.find(source_wallet_id)
      target_wallet = Wallet.find(target_wallet_id)

      debit_transaction = Transaction.new
      debit_transaction.source_wallet = source_wallet
      debit_transaction.target_wallet = target_wallet
      debit_transaction.amount = amount
      debit_transaction.transaction_type = :debit
      debit_transaction.save!(context: :transfer)

      credit_transaction = Transaction.new
      credit_transaction.source_wallet = target_wallet
      credit_transaction.target_wallet = source_wallet
      credit_transaction.amount = amount
      credit_transaction.transaction_type = :credit
      credit_transaction.save!
    end
  end

  private

  def sufficient_funds
    source_wallet&.with_lock do
      if source_wallet.balance < amount
        errors.add(:amount, "Insufficient balance")
      end
    end
  end
end

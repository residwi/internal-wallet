class StockTransaction < ApplicationRecord
  enum :transaction_type, { buy: "buy" }, validate: true

  belongs_to :source_wallet, class_name: "Wallet", foreign_key: "source_wallet_id"

  validates :source_wallet, presence: true
  validates :stock_name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def self.buy!(source_wallet_id:, stock_name:, quantity:, stock_price:)
    ActiveRecord::Base.transaction do
      source_wallet = Wallet.find(source_wallet_id)

      transaction = Transaction.new
      transaction.source_wallet = source_wallet
      transaction.amount = quantity * stock_price
      transaction.transaction_type = :debit
      transaction.save!(context: :buy)

      stock_transaction = StockTransaction.new
      stock_transaction.source_wallet = source_wallet
      stock_transaction.stock_name = stock_name
      stock_transaction.quantity = quantity
      stock_transaction.price = stock_price
      stock_transaction.transaction_type = :buy
      stock_transaction.save!
    end
  end
end

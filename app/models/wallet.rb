class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true
  has_many :transactions, foreign_key: "source_wallet_id"
  has_many :stock_transactions, foreign_key: "source_wallet_id"

  def balance
    @balance ||= calculate_balance
  end

  private

  def calculate_balance
    transactions.select("SUM(
        CASE
            WHEN transaction_type = 'credit' THEN amount
            WHEN transaction_type = 'debit' THEN -amount
            ELSE 0
        END
    ) AS balance").group(:source_wallet_id).order(:source_wallet_id).first.balance.to_f
  end
end

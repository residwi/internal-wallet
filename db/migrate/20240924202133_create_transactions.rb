class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :source_wallet, null: false, foreign_key: { to_table: :wallets }
      t.references :target_wallet, foreign_key: { to_table: :wallets }
      t.numeric :amount, precision: 20, scale: 2, null: false
      t.string :transaction_type, null: false

      t.timestamps
    end

    add_index :transactions, :transaction_type
  end
end

class CreateStockTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_transactions do |t|
      t.references :source_wallet, null: false, foreign_key: { to_table: :wallets }
      t.string :stock_name, null: false
      t.integer :quantity, null: false
      t.numeric :price, precision: 20, scale: 2, null: false
      t.string :transaction_type, null: false

      t.timestamps
    end

    add_index :stock_transactions, :transaction_type
  end
end

module Api
  class TransactionsController < ApplicationController
    before_action :set_source_wallet, only: %i[deposit withdraw]

    def transfer
      Transaction.transfer!(
        source_wallet_id: params[:source_wallet_id].to_i,
        target_wallet_id: params[:target_wallet_id].to_i,
        amount: params[:amount].to_f
      )

      render json: { message: "Transfer successful" }
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.messages }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { errors: e.message }, status: :internal_server_error
    end

    def deposit
      deposit_transaction = Transaction.new
      deposit_transaction.source_wallet = @source_wallet
      deposit_transaction.amount = params[:amount].to_f
      deposit_transaction.transaction_type = :credit

      if deposit_transaction.save
        render json: { message: "Deposit successful" }
      else
        render json: { errors: deposit_transaction.errors.messages }, status: :unprocessable_entity
      end
    end

    def withdraw
      withdraw_transaction = Transaction.new
      withdraw_transaction.source_wallet = @source_wallet
      withdraw_transaction.amount = params[:amount].to_f
      withdraw_transaction.transaction_type = :debit

      if withdraw_transaction.save(context: :withdraw)
        render json: { message: "Withdraw successful" }
      else
        render json: { errors: withdraw_transaction.errors.messages }, status: :unprocessable_entity
      end
    end

    private

    def set_source_wallet
      @source_wallet = Wallet.find_by(id: params[:source_wallet_id])
      if @source_wallet.nil?
        error_response = { errors: { source_wallet_id: "Wallet not found" } }
        render json: error_response, status: :unprocessable_entity
      end
    end
  end
end

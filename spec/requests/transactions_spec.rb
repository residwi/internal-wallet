require 'rails_helper'


RSpec.describe "/transactions", type: :request do
  let!(:source_wallet) { create :wallet, :for_user, :with_balance, balance: 100 }
  let!(:target_wallet) { create :wallet, :for_user }
  let!(:source_user_session) { create :session, user: source_wallet.walletable }

  let(:valid_headers) {
    { "Authorization" => "Bearer #{source_user_session.token}" }
  }

  describe "POST /transfer" do
    context "with valid parameters" do
      it "transfers the money successfully" do
        valid_params = {
          source_wallet_id: source_wallet.id,
          target_wallet_id: target_wallet.id,
          amount: 100
        }

        post api_transactions_transfer_path,
          params: valid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Transfer successful")
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid amount" do
      it "does not create a new transaction" do
        invalid_params = {
          source_wallet_id: source_wallet.id,
          target_wallet_id: target_wallet.id,
          amount: "stub-invalid-amount"
        }

        post api_transactions_transfer_path,
          params: invalid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid wallet" do
      it "does not create a new transaction" do
        invalid_params = {
          source_wallet_id: 1234,
          target_wallet_id: 4321,
          amount: 100
        }

        post api_transactions_transfer_path,
          params: invalid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with insufficient balance" do
      it "does not create a new transaction" do
        source_wallet = create :wallet, :for_user, :with_balance, balance: 1

        invalid_params = {
          source_wallet_id: source_wallet.id,
          target_wallet_id: target_wallet.id,
          amount: 999
        }

        post api_transactions_transfer_path,
          params: invalid_params, headers: valid_headers, as: :json


        error_response = JSON.parse(response.body)["errors"]
        expect(response).to have_http_status(:unprocessable_entity)
        expect(error_response["amount"].first).to eq("Insufficient balance")
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "POST /deposit" do
    context "with valid parameters" do
      it "deposits the money successfully" do
        valid_params = {
          source_wallet_id: source_wallet.id,
          amount: 10
        }

        post api_transactions_deposit_path,
          params: valid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Deposit successful")
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid amount" do
      it "does not create a new transaction" do
        invalid_params = {
          source_wallet_id: source_wallet.id,
          amount: "stub-invalid-amount"
        }

        post api_transactions_deposit_path,
          params: invalid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid wallet" do
      it "does not create a new transaction" do
        invalid_params = {
          source_wallet_id: 1234,
          amount: 50
        }

        post api_transactions_deposit_path,
          params: invalid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]["source_wallet_id"]).to eq("Wallet not found")
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "POST /withdraw" do
    context "with valid parameters" do
      it "withdraws the money successfully" do
        valid_params = {
          source_wallet_id: source_wallet.id,
          amount: 50
        }

        post api_transactions_withdraw_path,
          params: valid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Withdraw successful")
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid amount" do
      it "does not create a new transaction" do
        invalid_params = {
          source_wallet_id: source_wallet.id,
          amount: "stub-invalid-amount"
        }

        post api_transactions_withdraw_path,
          params: invalid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid wallet" do
      it "does not create a new transaction" do
        invalid_params = {
          source_wallet_id: 1234,
          amount: 50
        }

        post api_transactions_withdraw_path,
          params: invalid_params, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]["source_wallet_id"]).to eq("Wallet not found")
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with insufficient balance" do
      it "does not create a new transaction" do
        source_wallet = create :wallet, :for_user, :with_balance, balance: 1

        invalid_params = {
          source_wallet_id: source_wallet.id,
          amount: 999
        }

        post api_transactions_withdraw_path,
          params: invalid_params, headers: valid_headers, as: :json


        error_response = JSON.parse(response.body)["errors"]
        expect(response).to have_http_status(:unprocessable_entity)
        expect(error_response["amount"].first).to eq("Insufficient balance")
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end
end

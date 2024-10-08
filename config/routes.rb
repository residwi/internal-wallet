Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "sign_in", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"

  namespace :api do
    get "stocks", to: "stocks#index"
    get "stocks/:symbol", to: "stocks#show", as: :stock
    post "stocks/buy", to: "stocks#buy"

    post "transactions/transfer", to: "transactions#transfer"
    post "transactions/deposit", to: "transactions#deposit"
    post "transactions/withdraw", to: "transactions#withdraw"
  end
end

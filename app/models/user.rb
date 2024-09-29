class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  has_one :wallet, as: :walletable, dependent: :destroy
end

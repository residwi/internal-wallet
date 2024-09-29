class Team < ApplicationRecord
  has_many :team_memberships, dependent: :destroy
  has_many :members, through: :team_memberships, source: :user, dependent: :destroy
  has_one :wallet, as: :walletable, dependent: :destroy

  def member?(user)
    members.include?(user)
  end
end

class Session < ApplicationRecord
  belongs_to :user

  def token
    @token ||= signed_id
  end
end

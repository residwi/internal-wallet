require "rails_helper"

RSpec.describe User, type: :model do
  describe "relations" do
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
    it { is_expected.to have_one(:wallet).dependent(:destroy) }
  end
end

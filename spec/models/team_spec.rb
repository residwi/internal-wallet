require "rails_helper"

RSpec.describe Team, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:members).through(:team_memberships).source(:user).dependent(:destroy) }
    it { is_expected.to have_one(:wallet).dependent(:destroy) }
  end

  describe "#member?" do
    let!(:team) { create :team }
    let!(:user) { create :user }

    context "when the user is a member of the team" do
      before do
        team.members << user
      end

      it "returns true" do
        expect(team.member?(user)).to be true
      end
    end

    context "when the user is not a member of the team" do
      it "returns false" do
        expect(team.member?(user)).to be false
      end
    end
  end
end

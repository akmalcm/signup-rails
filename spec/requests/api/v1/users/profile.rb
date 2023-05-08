require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe "#profile" do
    let!(:user) { create(:user) }

    before { get "/api/v1/users/profile", headers: auth_user_header(user) }

    context "without authorization" do
      let!(:user) { nil }

      it 'return errors' do
        expect(json["message"]).to eq("Invalid token.")
      end
    end

    context "with authorization" do
      it 'return profile' do
        expect(json["code"]).to eq("success")
        expect(json.dig("data", "user", "id")).to eq(user.id)
      end
    end
  end
end

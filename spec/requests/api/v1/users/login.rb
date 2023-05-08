require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe "#login" do
    let!(:user) { create(:user) }

    before { post "/api/v1/users/login", params: param }

    context "valid email" do
      let(:param) { { email: user.email, password: user.password } }

      it 'return user with token' do
        expect(json["code"]).to eq("success")
        expect(json["message"]).to eq("Successfully logged in.")
        expect(json.dig("data", "user", "id")).to eq(user.id)
        expect(json.dig("data", "token")).not_to be_nil
      end
    end

    context "invalid email" do
      let(:param) { { email: 'invalid@email.com' } }

      it 'return errors' do
        expect(json["code"]).to eq("failed")
        expect(json["message"]).to eq("Invalid email or password.")
      end
    end

    context "invalid password" do
      let(:param) { { email: user.email, password: 'invalid_password' } }

      it 'return errors' do
        expect(json["code"]).to eq("failed")
        expect(json["message"]).to eq("Invalid email or password.")
      end
    end
  end
end

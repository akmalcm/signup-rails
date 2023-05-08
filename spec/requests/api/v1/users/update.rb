require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe "#update" do
    let!(:user) { create(:user) }
    let(:params) do
      {
        name: "test",
        email: "test@email.com",
        phone: "0123456789",
        password: "12345",
        password_confirmation: "12345"
      }
    end

    before { patch "/api/v1/users/update", params: params, headers: auth_user_header(user) }

    context "valid params" do
      it 'return user with token' do
        expect(json["code"]).to eq("success")
        expect(json["message"]).to eq("User updated successfully.")
        expect(json.dig("data", "user", "name")).to eq(params[:name])
      end
    end

    context "invalid params" do
      let(:params) { { name: nil, email: nil, phone: nil, password: nil } }

      it 'return errors' do
        expect(json["code"]).to eq("unprocessable_entity")
        expect(json["message"]).to include("Name can't be blank", "Email can't be blank", "Phone can't be blank",
                                           "Password can't be blank")
        expect(json["data"]).to be_nil
      end

      context "updating password" do
        let(:params) { { password: '12345', password_confirmation: '67890' } }

        it 'return errors' do
          expect(json["code"]).to eq("unprocessable_entity")
          expect(json["message"]).to include("Password confirmation doesn't match Password")
          expect(json["data"]).to be_nil
        end
      end
    end

    context "Unauthorized" do
      let(:user) { nil }

      it 'return unauthorized' do
        subject
        expect(json["code"]).to eq("unauthorized")
        expect(json["message"]).to eq("Invalid token.")
      end
    end
  end
end

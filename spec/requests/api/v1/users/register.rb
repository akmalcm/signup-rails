require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe "#register" do
    let(:params) do
      {
        name: "test",
        email: "test@email.com",
        phone: "0123456789",
        password: "12345",
        password_confirmation: "12345"
      }
    end

    before { post "/api/v1/users/register", params: params }

    context "valid params" do
      it 'return success with user' do
        expect(json["code"]).to eq("success")
        expect(json["message"]).to eq("User registered successfully.")
        expect(json.dig("data", "user", "name")).to eq(params[:name])
      end
    end

    context "invalid params" do
      let(:params) { nil }

      it 'return errors' do
        expect(json["code"]).to eq("unprocessable_entity")
        expect(json["message"]).to include("Name can't be blank", "Email can't be blank", "Phone can't be blank",
                                           "Password can't be blank")
        expect(json["data"]).to be_nil
      end

      context "password confirmation blank" do
        let(:params) { { password: '12345', password_confirmation: '' } }

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

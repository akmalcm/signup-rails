require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe "#destroy" do
    subject { delete "/api/v1/users", headers: auth_user_header(user) }

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

    context "successful delete" do
      it 'return user with token' do
        subject
        expect(json["code"]).to eq("success")
        expect(json["message"]).to eq("User deleted successfully.")
        expect(User.count).to eq(0)
      end
    end

    context "Unauthorized" do
      subject { delete "/api/v1/users", headers: auth_user_header(nil) }

      it 'return unauthorized' do
        subject
        expect(json["code"]).to eq("unauthorized")
        expect(json["message"]).to eq("Invalid token.")
      end
    end

    context "error while destroy" do
      it 'return errors' do
        allow_any_instance_of(User).to receive(:destroy).and_return(false)
        subject
        expect(json["code"]).to eq("unprocessable_entity")
        expect(json["message"]).not_to be_nil
        expect(json["data"]).to be_nil
      end
    end
  end
end

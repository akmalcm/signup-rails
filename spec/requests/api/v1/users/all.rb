require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe "#all" do
    let!(:user) { create(:user) }

    before { get "/api/v1/users/all" }

    it 'return all users' do
      expect(json.count).to eq(1)
      expect(json["users"].first["name"]).to eq(user.name)
    end
  end
end

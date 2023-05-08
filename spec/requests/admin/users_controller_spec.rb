require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do
  let!(:user) { create(:user) }
  let(:params) do
    {
      name: "test",
      email: "test@email.com",
      phone: "0123456789",
      password: "testa",
      password_confirmation: "testa"
    }
  end

  context "get index" do
    it 'return success' do
      get admin_users_path

      expect(response).to be_successful
      expect(response.body).to include(user.name)
    end
  end

  context "get new" do
    it 'return success' do
      get new_admin_user_url

      expect(response).to be_successful
      expect(response.body).to include("New User")
    end
  end

  context "create user" do
    it 'return success' do
      post admin_users_url, params: { user: params }

      expect(response).to be_redirect
      expect(response.redirect_url).to eq(admin_user_url(User.last))
      expect(User.count).to eq(2)
    end
  end

  context "show user" do
    it 'return success' do
      get admin_user_url(user)

      expect(response).to be_successful
    end
  end

  context "get edit" do
    it 'return success' do
      get edit_admin_user_url(user)

      expect(response).to be_successful
      expect(response.body).to include(user.name)
    end
  end

  context "update user" do
    it 'return success' do
      patch admin_user_url(user), params: { user: params }

      expect(response).to be_redirect
      expect(response.redirect_url).to eq(admin_user_url(user))
      expect(user.reload.name).to eq(params[:name])
    end
  end

  context "destroy user" do
    it 'return success' do
      delete admin_user_url(user)

      expect(response).to be_redirect
      expect(response.redirect_url).to eq(admin_users_url)
      expect(User.count).to eq(0)
    end
  end
end

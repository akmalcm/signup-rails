module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.all.order(:id)
    end

    def show; end

    def new
      @user = User.new
    end

    def edit; end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_user_url(@user), notice: 'User was successfully created.'
      else
        render :new
      end
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_url(@user), notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      if @user.destroy
        redirect_to admin_users_url, notice: 'User was successfully destroyed.'
      else
        redirect_to admin_users_url, notice: 'Unable to delete user.'
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation).tap do |param|
        param[:password_confirmation] = param[:password_confirmation].presence || ''
      end
    end
  end
end

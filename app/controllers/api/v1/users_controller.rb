module Api
  module V1
    class UsersController < Api::BaseController
      before_action :authorize_request, except: %i[all register login]

      def all
        @users = User.all.order(:id)
        render jsonapi: @users, each_serializer: Api::V1::UserSerializer
      end

      def profile
        render jsonapi: @user = @current_user, serializer: Api::V1::UserSerializer
      rescue ActiveRecord::RecordNotFound
        error('User does not exist.', :not_found)
      end

      def register
        @user = User.new(user_params)
        if @user.save
          @message = 'User registered successfully.'
          render jsonapi: @user, serializer: Api::V1::UserSerializer
        else
          error(@user.errors.full_messages.join(", "), :unprocessable_entity)
        end

      end

      def login
        @user = User.find_by(email: params[:email])
        if @user&.authenticate(params[:password])
          @message = "Successfully logged in."
          @token = JwtHelper.encode(user_id: @user.id)
          @time = Time.current + 24.hours.to_i
          @time = @time.strftime('%m-%d-%Y %H:%M')
          render jsonapi: @user, serializer: Api::V1::UserSerializer
        else
          error('Invalid email or password.', 'failed')
        end
      end

      def update
        if @current_user.update(user_params)
          @message = 'User updated successfully.'
          render jsonapi: @user = @current_user, serializer: Api::V1::UserSerializer, status: :ok
        else
          error(@current_user.errors.full_messages.join(", "), :unprocessable_entity)
        end
      end

      def destroy
        if @current_user.destroy
          @message = 'User deleted successfully.'
        else
          error(@current_user.errors.full_messages.join(", "), :unprocessable_entity)
        end
      end

      private

      def user_params
        params.permit(:name, :email, :phone, :password, :password_confirmation).tap do |param|
          param[:password_confirmation] = param[:password_confirmation].presence || ''
        end
      end
    end
  end
end

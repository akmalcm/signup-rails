module Api
  module V1
    module Api
      module V1
        class UsersController < Api::V1::BaseController
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
              @message = 'user registered successfully.'
              render jsonapi: @user, serializer: Api::V1::UserSerializer
            else
              error(@user.errors, :unprocessable_entity)
            end
          end

          def login
            @user = User.find_by(email: params[:email])
            if @user&.authenticate(params[:password])
              @token = JWTHelper.encode(user_id: @user.id)
              @time = Time.current + 24.hours.to_i
              @time = @time.strftime('%m-%d-%Y %H:%M')
              render jsonapi: @user, serializer: Api::V1::UserSerializer
            else
              error('Invalid email or password.', 'failed')
            end
          end

          def update
            if @current_user.update(user_params)
              @message = 'user updated successfully.'
              render jsonapi: @user = @current_user, serializer: Api::V1::UserSerializer, status: :ok
            else
              error(@user.errors, :unprocessable_entity)
            end
          end

          def destroy
            @user.destroy

            respond_to do |format|
              format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
              format.json { head :no_content }
            end
          end

          private

          def user_params
            params.permit(:name, :email, :phone, :password, :password_confirmation)
          end
        end
      end
    end
  end
end
